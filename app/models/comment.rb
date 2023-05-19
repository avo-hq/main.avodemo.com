# == Schema Information
#
# Table name: comments
#
#  id               :bigint           not null, primary key
#  commentable_type :string
#  commentable_id   :integer
#  body             :text
#  user_id          :bigint
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
class Comment < ApplicationRecord
  belongs_to :commentable, polymorphic: true, optional: true
  belongs_to :user, optional: true

  scope :starts_with, ->(prefix) { where("LOWER(body) LIKE ?", "#{prefix}%") }

  def tiny_name
    ActionView::Base.full_sanitizer.sanitize(body).truncate 30
  end

  def self.ransackable_attributes(auth_object = nil)
    ["body", "commentable_id", "commentable_type", "created_at", "id", "updated_at", "user_id"]
  end
end
