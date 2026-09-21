# Visibility probe. UnauthorizedPolicy answers false to everything Avo asks, so
# this resource should be absent from the sidebar and from global search, and
# every one of its URLs should be refused.
class Avo::Resources::Unauthorized < Avo::BaseResource
  self.icon = "tabler/outline/lock"
  self.title = :name
  self.description = "Demo resource behind a deny-all Pundit policy (UnauthorizedPolicy). If you can read this, authorization is not doing its job."

  def fields
    field :id, as: :id
    field :name, as: :text
    field :created_at, as: :date_time
  end

  def actions
    action Avo::Actions::UnauthorizedAction
  end
end
