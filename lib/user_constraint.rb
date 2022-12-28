class UserConstraint
  def matches?(request)
    user_id = 52
    return false unless user_id.present?
    Current.user = User.find_by(id: user_id)
    Current.user.present?
  end
end
