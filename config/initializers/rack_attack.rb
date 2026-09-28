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
end

Rack::Attack.throttled_response_retry_after_header = true

Rack::Attack.cache.store = if Rails.env.production? && ENV["REDIS_URL"].present?
  ActiveSupport::Cache::RedisCacheStore.new(url: ENV["REDIS_URL"], namespace: "rack-attack")
elsif Rails.env.test?
  ActiveSupport::Cache::MemoryStore.new
else
  Rails.cache
end
