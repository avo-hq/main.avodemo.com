class TeamPolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    true
  end

  def create?
    true
  end

  def new?
    create?
  end

  def update?
    true
  end

  def edit?
    update?
  end

  def destroy?
    true
  end

  def preview?
    true
  end

  # The methods below control the level of access to the `memberships` association

  def attach_memberships?
    false
  end

  def create_memberships?
    false
  end

  # Turn this to true if you want to hide the whole "Memberships" poanel in a Team
  def view_memberships?
    true
  end

  def show_memberships?
    false
  end

  def edit_memberships?
    false
  end

  def detach_memberships?
    false
  end

  def destroy_memberships?
    false
  end

  def act_on?
    true
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
