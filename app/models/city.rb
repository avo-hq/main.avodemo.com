class City < ApplicationRecord
  enum status: {Open: "open", Closed: "closed", Quarantine: "On Quarantine"}
  # has_rich_text :description
  # has_one_attached :description_file

  def random_image=(value)
  end

  def random_image
    "https://source.unsplash.com/random"
  end

  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "description", "features", "id", "image_url", "is_capital", "metadata", "name", "population", "status", "tiny_description", "updated_at"]
  end
end
