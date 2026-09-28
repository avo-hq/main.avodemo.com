class Avo::Ai::FeedbackPolicy < ApplicationPolicy
  def index? = reviewer?
  def show? = reviewer?
  def edit? = reviewer?
  def update? = reviewer?
  def search? = reviewer?
  def act_on? = reviewer?

  def new? = false
  def create? = false
  def destroy? = false

  class Scope < ApplicationPolicy::Scope
    def resolve
      user&.is_admin? ? scope.all : scope.none
    end
  end

  private

  def reviewer?
    user&.is_admin? || false
  end
end
