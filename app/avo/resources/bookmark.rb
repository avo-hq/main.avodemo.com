class Avo::Resources::Bookmark < Avo::Resources::ArrayResource
  self.icon = "tabler/outline/bookmark"
  self.description = "Demo ArrayResource with read and write. Records come from a JSON file, and the resource writes changes back to it."
  self.writable = true

  def records = BookmarkStore.all

  def save_record(record)
    record.id = BookmarkStore.save(id: record.id&.to_i, title: record.title, url: record.url)
  end

  def destroy_record(record) = BookmarkStore.destroy(record.id)

  def fields
    field :id, as: :id
    field :title, as: :text, required: true
    field :url, as: :text
  end
end
