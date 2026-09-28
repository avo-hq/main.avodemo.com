RubyLLM.configure do |config|
  config.ollama_api_base = ENV.fetch("OLLAMA_API_BASE", "http://localhost:11434/v1")
  config.default_model = ENV.fetch("RUBYLLM_DEFAULT_MODEL", ENV["DEEPSEEK_API_KEY"].present? ? "deepseek-flash" : "gpt-5.6-luna")
  config.deepseek_api_key = ENV["DEEPSEEK_API_KEY"].presence
  config.openai_api_key = ENV["OPENAI_API_KEY"].presence
  config.anthropic_api_key = ENV["ANTHROPIC_API_KEY"].presence
  config.gemini_api_key = ENV["GEMINI_API_KEY"].presence
  config.logger = Rails.logger
end
