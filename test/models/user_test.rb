require "test_helper"

class UserTest < ActiveSupport::TestCase
  def create_user(email)
    User.create!(first_name: "Avo", last_name: "Cado", email: email, password: "secreto", roles: {admin: true})
  end

  test "nobody can change how everyone signs in to the shared demo account" do
    demo = create_user(User::DEMO_EMAIL)

    {email: "mine@example.com", password: "hijacked", active: false, roles: {admin: false}}.each do |attribute, value|
      demo.reload.assign_attributes(attribute => value)

      refute demo.save, "#{attribute} changed on the shared demo account"
    end
    assert User.find_by(email: User::DEMO_EMAIL).valid_password?("secreto")
  end

  test "the shared demo account still takes ordinary edits" do
    demo = create_user(User::DEMO_EMAIL)

    assert demo.update(first_name: "Avocado")
  end

  test "the shared demo account can't be deleted, other users can" do
    demo = create_user(User::DEMO_EMAIL)
    other = create_user("someone@example.com")

    refute demo.destroy
    assert User.exists?(demo.id)
    assert other.destroy
    refute User.exists?(other.id)
  end

  test "the policy hides delete on the shared demo account only" do
    demo = create_user(User::DEMO_EMAIL)
    other = create_user("someone@example.com")

    refute UserPolicy.new(demo, demo).destroy?
    assert UserPolicy.new(demo, other).destroy?
  end
end
