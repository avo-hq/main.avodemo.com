class AuthorPolicy < ApplicationPolicy
  def new? = false
  def create? = false
  def update? = false
  def destroy? = false
  def show? = false
  def edit? = false
  def index? = true
  def show? = true

  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
    def resolve
      scope.all
    end
  end
end
