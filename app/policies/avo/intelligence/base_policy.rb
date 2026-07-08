# Shared base for the avo-intelligence resource policies (Chat, Message, Model, ToolCall).
# The AI chat admin resources are restricted to a single internal account, so every
# action -- including the Scope backing index/search -- is denied unless the signed-in
# user matches AUTHORIZED_EMAIL. The "Intelligence" menu section in avo.rb authorizes
# against ChatPolicy's index? to keep the sidebar entries hidden for everyone else too.
class Avo::Intelligence::BasePolicy < ApplicationPolicy
  AUTHORIZED_EMAIL = "avo-chat@cado.com"

  def index? = authorized_user?
  def show? = authorized_user?
  def create? = authorized_user?
  def new? = create?
  def update? = authorized_user?
  def edit? = update?
  def destroy? = authorized_user?
  def act_on? = authorized_user?
  def search? = authorized_user?

  class Scope < ApplicationPolicy::Scope
    def resolve
      return scope.all if user&.email == AUTHORIZED_EMAIL

      scope.none
    end
  end

  private

  def authorized_user?
    user&.email == AUTHORIZED_EMAIL
  end
end
