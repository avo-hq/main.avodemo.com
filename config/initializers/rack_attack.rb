class Rack::Attack
  AI_GENERATION_PATH = %r{\A/avo/chats(?:\z|/[^/]+/(?:messages(?:/retry)?|rename)\z)}

  def self.ai_generation_request?(request)
    request.post? && request.path.match?(AI_GENERATION_PATH)
  end

  throttle("avo-ai/ip/minute", limit: 5, period: 1.minute) do |request|
    request.ip if ai_generation_request?(request)
  end

  throttle("avo-ai/ip/hour", limit: 30, period: 1.hour) do |request|
    request.ip if ai_generation_request?(request)
  end

  throttle("avo-ai/global/day", limit: 300, period: 1.day) do |request|
    "all" if ai_generation_request?(request)
  end

  # Per IP only. Everyone signs in as the same demo account, so a per-email
  # limit would lock the whole demo out.
  throttle("sign-in/ip", limit: 10, period: 1.minute) do |request|
    request.ip if request.post? && request.path == "/users/sign_in"
  end

  throttle("sign-up/ip", limit: 5, period: 1.hour) do |request|
    request.ip if request.post? && request.path == "/users"
  end

  # Both asking for the email and submitting the new password.
  throttle("password-reset/ip", limit: 5, period: 1.hour) do |request|
    request.ip if (request.post? || request.put? || request.patch?) && request.path == "/users/password"
  end

  # Direct uploads, plus Avo forms and editors posting files inline.
  def self.upload_request?(request)
    return false unless request.post? || request.put? || request.patch?

    request.path == "/rails/active_storage/direct_uploads" ||
      (request.path.start_with?("/avo") && request.media_type == "multipart/form-data")
  end

  throttle("uploads/ip/minute", limit: 30, period: 1.minute) do |request|
    request.ip if upload_request?(request)
  end

  throttle("uploads/ip/day", limit: 300, period: 1.day) do |request|
    request.ip if upload_request?(request)
  end
end

Rack::Attack.throttled_response_retry_after_header = true

# ponytail: Rails.cache counts per machine; fine for one server, use solid_cache if we scale out.
Rack::Attack.cache.store = Rails.env.test? ? ActiveSupport::Cache::MemoryStore.new : Rails.cache
