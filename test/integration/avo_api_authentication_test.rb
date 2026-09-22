require "test_helper"

# The REST API is mounted OUTSIDE the Devise `authenticate` block that guards the
# panel, so whatever answers `setup_authentication` on
# Avo::Api::Resources::V1::BaseResourcesController is the only thing standing
# between these endpoints and the open internet.
#
# That controller now overrides nothing: avo-api's own implementation runs, and it
# accepts one credential -- a bearer token -- or answers 401. Both overrides this
# app has had were weaker than that. The first opened with `return true`
# ("disable authentication for now") above a block of HTTP Basic code that
# therefore never ran, and every endpoint on a public host answered anyone, DELETE
# included. The second accepted HTTP Basic beside the token, a second credential
# path maintained here rather than in the gem.
#
# These hold the door shut, and the Basic case below is what keeps the removed
# path from drifting back in.
#
# Deliberately credential-free: refusal is the regression worth guarding, and
# asserting it needs no user, no fixture and no licence. The accepting path -- a
# valid bearer token -- is exercised by avo-api's own suite.
class AvoApiAuthenticationTest < ActionDispatch::IntegrationTest
  # https on purpose, matching McpServerRoutesTest: plain http is refused outside
  # localhost.
  ORIGIN = "https://main.avodemo.com".freeze
  USERS = "#{ORIGIN}/api/resources/v1/users".freeze

  test "refuses a read carrying no credential" do
    get USERS

    assert_response :unauthorized
    assert_equal({"error" => "Unauthorized"}, response.parsed_body)
  end

  test "refuses a bearer token that matches nothing" do
    get USERS, headers: {"Authorization" => "Bearer not-a-real-token"}

    assert_response :unauthorized
  end

  # HTTP Basic is no longer a credential this API knows, whether or not the pair
  # would have matched a user. Asserted with a pair that *does* match the seeded
  # demo account precisely because the old override would have accepted it: a
  # wrong pair would pass this test even if Basic came back.
  test "refuses HTTP Basic, even a pair that matches a real user" do
    get USERS, headers: {
      "Authorization" => ActionController::HttpAuthentication::Basic.encode_credentials("avo@avohq.io", "secreto")
    }

    assert_response :unauthorized
  end

  # The one that actually cost something: a write reachable by anyone is worse than a
  # read, and `return true` left every verb open, not just GET.
  test "refuses a delete carrying no credential" do
    delete "#{USERS}/1"

    assert_response :unauthorized
  end

  test "refuses a create carrying no credential" do
    post USERS, params: {user: {first_name: "Nobody"}}

    assert_response :unauthorized
  end
end
