class UserPolicy < BaseAvoPolicy
  # Hides the delete control on the shared demo login; User refuses the
  # delete anyway (see User::DEMO_EMAIL).
  def destroy? = !(record.is_a?(User) && record.demo_account?)
end
