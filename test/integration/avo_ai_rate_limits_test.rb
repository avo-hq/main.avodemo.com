require "test_helper"

class AvoAiRateLimitsTest < ActiveSupport::TestCase
  setup do
    Rack::Attack.cache.store.clear
    @app = Rack::Attack.new(->(_env) { [200, {"Content-Type" => "text/plain"}, ["OK"]] })
  end

  test "limits one IP to five AI requests per minute" do
    5.times { assert_equal 200, request("/avo/chats/1/messages", ip: "192.0.2.1") }

    assert_equal 429, request("/avo/chats/1/messages", ip: "192.0.2.1")
  end

  test "limits AI generation globally to 300 requests per day" do
    300.times do |index|
      ip = "198.#{index / 256}.#{index % 256}.1"
      assert_equal 200, request("/avo/chats", ip: ip)
    end

    assert_equal 429, request("/avo/chats", ip: "203.0.113.1")
  end

  test "does not limit unrelated requests" do
    10.times { assert_equal 200, request("/avo/resources/users", ip: "192.0.2.1") }
  end

  private

  def request(path, ip:)
    Rack::MockRequest.new(@app).post(path, "REMOTE_ADDR" => ip).status
  end
end
