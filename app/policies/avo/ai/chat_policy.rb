# Shadows the gem's owner-only policy, so it keeps its owner rules: a chat is readable by the user
# who started it and nobody else, on the admin resources and through the query tool alike.
class Avo::Ai::ChatPolicy < Avo::Ai::BasePolicy
  def show? = owner?
  def update? = owner?
  def destroy? = owner?
  def act_on? = owner?

  def debug_level
    user&.is_admin? ? :tools : :off
  end

  def available_models
    models = [
      {model: "gpt-5.6-luna", provider: :openai},
      {model: "gemini-3.5-flash-lite", provider: :gemini},
    ]

    models.insert(1, {model: "deepseek-flash", provider: :deepseek}) if ENV["DEEPSEEK_API_KEY"].present?
    models
  end

  class Scope < ApplicationPolicy::Scope
    def resolve = user ? scope.where(user:) : scope.none
  end

  private

  def owner? = user.present? && record.user == user
end
