require "test_helper"

# The avo-mcp_server endpoints are machine-called with a bearer token and no browser
# session, so they must answer outside the Devise `authenticate` block that guards the
# panel — and before `mount_avo`, or Avo's engine swallows `/avo/mcp`. These requests
# carry no session; a sign-in redirect on any of them means the mount moved.
class McpServerRoutesTest < ActionDispatch::IntegrationTest
  # https on purpose: plain http is refused outside localhost, because tokens would
  # travel in the clear.
  ORIGIN = "https://main.avodemo.com"

  test "protected resource metadata answers at the origin root without a session" do
    get "#{ORIGIN}/.well-known/oauth-protected-resource/avo/mcp"

    assert_response :ok
    assert_equal "application/json", response.media_type
    assert_equal "#{ORIGIN}/avo/mcp", response.parsed_body["resource"]
    assert_equal [ORIGIN], response.parsed_body["authorization_servers"]
  end

  test "authorization server metadata answers at the origin root without a session" do
    get "#{ORIGIN}/.well-known/oauth-authorization-server"

    assert_response :ok
    assert_equal ORIGIN, response.parsed_body["issuer"]
    assert_equal "#{ORIGIN}/avo/mcp/token", response.parsed_body["token_endpoint"]
  end

  test "the JSON-RPC endpoint challenges an unauthenticated client instead of redirecting to sign-in" do
    post "#{ORIGIN}/avo/mcp", params: {jsonrpc: "2.0", id: 1, method: "initialize"}.to_json,
      headers: {"Content-Type" => "application/json", "Accept" => "application/json, text/event-stream"}

    assert_response :unauthorized
    assert_match(/\ABearer /, response.headers["WWW-Authenticate"])
    assert_includes response.headers["WWW-Authenticate"], "resource_metadata="
  end
end
