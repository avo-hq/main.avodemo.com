# Permissive base policy for the demo's Avo resources.
#
# The app runs `config.explicit_authorization = true`, so this makes authorization
# explicit for every resource (rather than relying on the missing-policy = allowed
# fallback) while keeping the demo admin able to do everything — same intent as the
# existing per-resource policies (TeamPolicy, IssuePolicy, ...).
#
# Resource-specific policies inherit from this and override individual methods when
# they need to restrict something.
class BaseAvoPolicy < ApplicationPolicy
  def index? = true
  def show? = true
  def create? = true
  def new? = create?
  def update? = true
  def edit? = update?
  def destroy? = true
  def preview? = true
  def act_on? = true
  def search? = true

  class Scope < ApplicationPolicy::Scope
    def resolve
      # Defensive: AR-backed resources scope with `.all`; non-AR resources (HTTP
      # resources, POROs) may not respond to `.all`, so fall back to the scope.
      scope.respond_to?(:all) ? scope.all : scope
    end
  end
end
