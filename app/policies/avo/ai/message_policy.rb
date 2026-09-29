# Shadows the gem's owner-only policy: a transcript is readable only by the chat's owner.
class Avo::Ai::MessagePolicy < Avo::Ai::BasePolicy
  def show? = owner?
  def update? = owner?
  def destroy? = owner?
  def act_on? = owner?

  class Scope < ApplicationPolicy::Scope
    def resolve = user ? scope.where(chat: Avo::Ai::Chat.where(user:)) : scope.none
  end

  private

  def owner? = user.present? && record.chat.user == user
end
