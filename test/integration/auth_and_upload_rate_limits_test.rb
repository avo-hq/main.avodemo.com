require "test_helper"

class AuthAndUploadRateLimitsTest < ActiveSupport::TestCase
  setup do
    Rack::Attack.cache.store.clear
    @app = Rack::Attack.new(->(_env) { [200, {"Content-Type" => "text/plain"}, ["OK"]] })
  end

  test "limits one IP to ten sign-ins a minute, without locking out other IPs" do
    10.times { assert_equal 200, request(:post, "/users/sign_in", ip: "192.0.2.1") }

    assert_equal 429, request(:post, "/users/sign_in", ip: "192.0.2.1")
    assert_equal 200, request(:post, "/users/sign_in", ip: "192.0.2.2")
  end

  test "limits sign-ups to five an hour per IP" do
    5.times { assert_equal 200, request(:post, "/users", ip: "192.0.2.1") }

    assert_equal 429, request(:post, "/users", ip: "192.0.2.1")
  end

  test "counts reset requests and reset submissions together, five an hour per IP" do
    3.times { assert_equal 200, request(:post, "/users/password", ip: "192.0.2.1") }
    2.times { assert_equal 200, request(:put, "/users/password", ip: "192.0.2.1") }

    assert_equal 429, request(:post, "/users/password", ip: "192.0.2.1")
  end

  test "limits uploads, direct and inline, to thirty a minute per IP" do
    15.times { assert_equal 200, request(:post, "/rails/active_storage/direct_uploads", ip: "192.0.2.1") }
    15.times { assert_equal 200, request(:patch, "/avo/resources/projects/1", ip: "192.0.2.1", multipart: true) }

    assert_equal 429, request(:post, "/rails/active_storage/direct_uploads", ip: "192.0.2.1")
  end

  test "leaves ordinary Avo form posts and reads alone" do
    40.times { assert_equal 200, request(:patch, "/avo/resources/projects/1", ip: "192.0.2.1") }
    40.times { assert_equal 200, request(:get, "/users/sign_in", ip: "192.0.2.1") }
  end

  private

  def request(verb, path, ip:, multipart: false)
    env = {"REMOTE_ADDR" => ip}
    env["CONTENT_TYPE"] = "multipart/form-data; boundary=x" if multipart
    Rack::MockRequest.new(@app).request(verb.to_s.upcase, path, env).status
  end
end
