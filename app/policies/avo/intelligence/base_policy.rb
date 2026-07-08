# Shared base for the avo-intelligence resource policies (Chat, Message, Model, ToolCall).
# Access isn't tied to a user account -- it's a shared-secret unlock: every action
# (including the Scope backing index/search) is denied unless the ENV["INTELLIGENCE_ACCESS"]
# key matches the "intelligence_access" cookie, which visitors set for themselves on the
# General settings page (Avo::Forms::Settings::AppSettings). The "Intelligence" menu section
# in avo.rb authorizes against ChatPolicy's index? to keep the sidebar entries hidden until
# the right key is entered.
class Avo::Intelligence::BasePolicy < ApplicationPolicy
  def self.access_granted?
    key = ENV["INTELLIGENCE_ACCESS"]

    key.present? && key == Avo::Current.request.cookies["intelligence_access"]
  end

  def index? = access_granted?
  def show? = access_granted?
  def create? = access_granted?
  def new? = create?
  def update? = access_granted?
  def edit? = update?
  def destroy? = access_granted?
  def act_on? = access_granted?
  def search? = access_granted?

  class Scope < ApplicationPolicy::Scope
    def resolve
      return scope.all if Avo::Intelligence::BasePolicy.access_granted?

      scope.none
    end
  end

  private

  def access_granted?
    self.class.access_granted?
  end
end
