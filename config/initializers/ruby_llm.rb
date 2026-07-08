RubyLLM.configure do |config|
  config.ollama_api_base = ENV.fetch("OLLAMA_API_BASE", "http://localhost:11434/v1")
  config.default_model = ENV.fetch("RUBYLLM_DEFAULT_MODEL", "gpt-4o-mini")
  config.openai_api_key = ENV["OPENAI_API_KEY"].presence
  config.anthropic_api_key = ENV["ANTHROPIC_API_KEY"].presence
  config.use_new_acts_as = true
  config.model_registry_class = "Avo::Intelligence::Model"
  config.logger = Rails.logger
end


