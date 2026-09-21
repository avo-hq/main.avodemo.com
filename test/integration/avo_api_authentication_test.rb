require "test_helper"

# The REST API is mounted OUTSIDE the Devise `authenticate` block that guards the
# panel, so `setup_authentication` on Avo::Api::Resources::V1::BaseResourcesController
# is the only thing standing between these endpoints and the open internet.
#
# It once opened with `return true` -- "disable authentication for now" -- above a
# block of HTTP Basic code that therefore never ran. Every endpoint on a public host
# answered anyone, DELETE included, while the mount comment in `config/routes.rb` went
# on saying the API carried its own auth. These hold the door shut.
#
# Deliberately credential-free: refusal is the regression worth guarding, and asserting
# it needs no user, no fixture and no licence. The accepting paths (a valid bearer
# token, and the HTTP Basic pair the Http Users resource sends) are exercised by
# avo-api's own suite and by the panel itself.
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

  test "refuses an HTTP Basic pair that matches nothing" do
    get USERS, headers: {
      "Authorization" => ActionController::HttpAuthentication::Basic.encode_credentials("nobody@example.com", "wrong")
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
