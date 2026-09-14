# Authorizes the MCP connections resource (avo-mcp_server). The gem ships no policy
# for it on purpose — who sees and revokes which connections is the app's call —
# and with `config.explicit_authorization = true` the resource stays hidden until
# one answers `index?`.
#
# Every demo visitor is the same shared admin, so a per-owner scope (the shape the
# docs show) would be a no-op here; keep it as permissive as the other demo
# policies. Connections are created by authorizing a client and ended by revoking
# it, so the create/edit/destroy controls stay off.
# https://docs.avohq.io/4.0/mcp.html#decide-who-sees-and-revokes-what
class Avo::McpServer::ConnectionPolicy < ApplicationPolicy
  def index? = true
  def show? = true

  # Revoke. Avo asks once for the action itself (record is the class), then per selected connection.
  def act_on? = true

  # The cards below the fields. Each falls back to show? when undefined; spelled out so a
  # later restriction has a place to land.
  def view_log? = true
  def view_audit_trail? = true
  def view_entitlements? = true
  def view_tools? = true

  def create? = false
  def edit? = false
  def destroy? = false

  class Scope < ApplicationPolicy::Scope
    def resolve = scope.all
  end
end
