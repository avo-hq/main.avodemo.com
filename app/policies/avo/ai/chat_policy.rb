class Avo::Ai::ChatPolicy < Avo::Ai::BasePolicy
  def debug_level
    user&.is_admin? ? :tools : :off
  end

  def available_models
    [
      {model: "gpt-5.6-luna", provider: :openai},
      {model: "gpt-4o-mini", provider: :openai},
      {model: "claude-haiku-4-5", provider: :anthropic},
      {model: "gemini-2.5-flash-lite", provider: :gemini}
    ]
  end
end
