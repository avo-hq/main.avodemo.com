# Field authorization demo (AVO-622). The record is open to everyone, like every other
# demo resource; three of its fields are not, each through a different mechanism:
#
#   performance_rating  left out of the allowlist, so withheld everywhere
#   ssn                 on the denylist, so withheld everywhere
#   salary              shown in the admin panel, withheld from the REST API, the AI chat
#                       and MCP clients — the policy branches on Avo::Current.interface
#
# A withheld field is invisible AND unsettable: gone from index, show and edit, from the
# permitted params, from API payloads, from what the chat can read, filter or write, and
# from MCP tools.
class EmployeePolicy < BaseAvoPolicy
  def whitelisted_fields = %i[id name email department salary ssn hired_on notes created_at]

  def blacklisted_fields
    denied = [:ssn]
    denied << :salary unless Avo::Current.interface == :ui
    denied
  end
end
