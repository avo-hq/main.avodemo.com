# == Schema Information
#
# Table name: posts
#
#  id           :bigint           not null, primary key
#  name         :string
#  body         :text
#  is_featured  :boolean
#  published_at :datetime
#  user_id      :bigint
#  custom_css   :text
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  status       :integer
#
class Post < ApplicationRecord
  enum status: [:draft, :published, :archived]

  validates :name, presence: true

  has_one_attached :cover_photo
  has_many_attached :trix_attachments

  belongs_to :user, optional: true
  has_many :comments, as: :commentable

  def cdn_cover_photo
    "#{ENV['CDN_URL']}#{cover_photo.key}" if cover_photo.attached?
  end
end
