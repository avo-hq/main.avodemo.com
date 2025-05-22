class Event < ApplicationRecord
  has_one_attached :profile_photo
  has_one_attached :cover_photo
end
