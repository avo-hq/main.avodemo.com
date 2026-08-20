class Avo::Ai::ChatPolicy < Avo::Ai::BasePolicy
  def debug_level
    account_user&.is_admin? ? :tools : :off
  end

  def available_models
    [
      {model: "gpt-5.6-luna", provider: :openai},
      {model: "gpt-4o-mini", provider: :openai},
      {model: "claude-haiku-4-5", provider: :anthropic},
      {model: "claude-sonnet-5", provider: :anthropic},
      {model: "gpt-4o", provider: :openai},
      {model: "claude-opus-4-8", provider: :anthropic},
      {model: "gemini-3.1-pro-preview", provider: :gemini}
    ]
  end
end
