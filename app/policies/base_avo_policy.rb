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
  def reorder? = true

  # avo-collaboration gates the timeline on these methods. With
  # explicit_authorization, a missing method = denied, so the timeline stays
  # hidden unless they're defined. Permissive here to match the demo intent.
  def collaboration_view_timeline? = true
  def collaboration_create_entry? = true
  def collaboration_destroy_entry? = true

  class Scope < ApplicationPolicy::Scope
    def resolve
      # Only ActiveRecord scopes get `.all`. ArrayResource models respond to
      # `.all` but it raises (avo array_resource.rb:26), and HTTP/PORO models
      # have no such method, so everything else is returned as-is.
      scope.is_a?(Class) && scope < ActiveRecord::Base ? scope.all : scope
    end
  end
end
