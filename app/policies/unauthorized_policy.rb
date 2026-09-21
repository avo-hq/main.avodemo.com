# Denies everything, on purpose.
#
# Unlike the rest of the demo's policies this does not inherit from
# BaseAvoPolicy -- that one is permissive, and inheriting only to override every
# method back to false would hide the intent. ApplicationPolicy already denies
# the CRUD set; the methods are spelled out anyway so "rejects all methods" is
# readable in one screen rather than inferred from a parent class.
#
# The app runs `config.explicit_authorization = true`, so a method this policy
# does not define is denied as well. Nothing here can accidentally open up.
class UnauthorizedPolicy < ApplicationPolicy
  def index? = false
  def show? = false
  def create? = false
  def new? = false
  def update? = false
  def edit? = false
  def destroy? = false
  def preview? = false
  def act_on? = false
  def search? = false
  def reorder? = false

  def collaboration_view_timeline? = false
  def collaboration_create_entry? = false
  def collaboration_destroy_entry? = false

  class Scope < ApplicationPolicy::Scope
    # Belt and braces: even a query that slips past the method checks returns
    # nothing.
    def resolve = scope.none
  end
end
