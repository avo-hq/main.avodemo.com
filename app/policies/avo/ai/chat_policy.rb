class Avo::Ai::ChatPolicy < Avo::Ai::BasePolicy
  def debug_level
    user&.is_admin? ? :tools : :off
  end

  def available_models
    models = [
      {model: "gpt-4o-mini", provider: :openai},
      {model: "gemini-2.5-flash-lite", provider: :gemini}
    ]

    models.prepend({model: "deepseek-flash", provider: :deepseek}) if ENV["DEEPSEEK_API_KEY"].present?
    models
  end
end
