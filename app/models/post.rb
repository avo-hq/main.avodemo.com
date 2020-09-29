class Post < ApplicationRecord
  validates :name, presence: true

  has_one_attached :cover_photo

  belongs_to :user, optional: true

  def cdn_cover_photo
    "#{ENV['CDN_URL']}#{cover_photo.key}" if cover_photo.attached?
  end
end
