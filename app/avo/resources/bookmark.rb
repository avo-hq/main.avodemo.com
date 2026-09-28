class Avo::Resources::Bookmark < Avo::Resources::ArrayResource
  self.icon = "tabler/outline/bookmark"
  self.description = "Demo ArrayResource with read and write. Records come from a JSON file, and the controller writes changes back to it."

  def records = BookmarkStore.all

  # Core derives the form's param key from ActiveRecord's base_class.
  def form_scope = "bookmark"

  def fields
    field :id, as: :id
    field :title, as: :text, required: true
    field :url, as: :text
  end
end
