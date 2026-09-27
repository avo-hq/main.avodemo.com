require "test_helper"

# The Employee resource exists to check field authorization live. These pin what the policy
# declares, so the demo keeps showing one field per mechanism: an allowlist omission, a
# denylist entry, and a field withheld only outside the admin panel.
class EmployeePolicyTest < ActiveSupport::TestCase
  def lists(interface)
    Avo::Current.interface = interface
    policy = EmployeePolicy.new(nil, Employee.new)
    [policy.whitelisted_fields, policy.blacklisted_fields]
  ensure
    Avo::Current.reset
  end

  test "leaves performance_rating off the allowlist" do
    allowed, _ = lists(:ui)

    refute_includes allowed, :performance_rating
  end

  test "denies ssn on every interface" do
    %i[ui api ai mcp].each do |interface|
      _, denied = lists(interface)

      assert_includes denied, :ssn, "ssn reachable through #{interface}"
    end
  end

  test "shows salary in the admin panel and withholds it everywhere else" do
    _, denied = lists(:ui)
    refute_includes denied, :salary

    %i[api ai mcp].each do |interface|
      _, denied = lists(interface)

      assert_includes denied, :salary, "salary reachable through #{interface}"
    end
  end
end
