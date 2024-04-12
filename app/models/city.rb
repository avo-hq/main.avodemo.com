class City < ApplicationRecord
  has_rich_text :description
  has_one_attached :description_file

  def random_image=(value)
  end

  def random_image
    "https://source.unsplash.com/random"
  end
end
