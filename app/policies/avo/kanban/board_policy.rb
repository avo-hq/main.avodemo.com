class Avo::Kanban::BoardPolicy < ApplicationPolicy
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

  # Kanban-specific predicates. Each maps to an `authorize_action(:action)` call
  # inside avo-kanban's board controllers and components.
  # https://docs.avohq.io/4.0/kanban-boards.html
  def add_column?
    true
  end

  def add_item?
    true
  end

  def manage_column?
    true
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
