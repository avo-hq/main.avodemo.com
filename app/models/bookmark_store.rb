# Backing store for the Bookmark array resource: a JSON file instead of a table.
# It resets on deploy, which is fine for a demo.
module BookmarkStore
  PATH = Rails.root.join("tmp", "bookmarks.json")

  SEED = [
    {id: 1, title: "Avo", url: "https://avohq.io"},
    {id: 2, title: "Avo docs", url: "https://docs.avohq.io"},
    {id: 3, title: "Ruby on Rails", url: "https://rubyonrails.org"}
  ]

  extend self

  # Falls back to the seed when the file is missing or emptied, so the
  # resource always has records to build its model class from.
  def all
    records = PATH.exist? ? JSON.parse(PATH.read, symbolize_names: true) : []
    records.presence || SEED
  end

  def save(attributes)
    records = all
    attributes[:id] ||= records.map { _1[:id] }.max.to_i + 1
    records.reject! { _1[:id] == attributes[:id] }
    write(records << attributes)
    attributes[:id]
  end

  def destroy(id)
    write(all.reject { _1[:id] == id.to_i })
  end

  private

  def write(records)
    PATH.write(JSON.pretty_generate(records.sort_by { _1[:id] }))
  end
end
