class Event < ApplicationRecord
  has_one_attached :profile_photo
  has_one_attached :cover_photo

  include AttachmentLimits
  limit_attachment :profile_photo, content_types: AttachmentLimits::IMAGES, max_size: 5.megabytes
  limit_attachment :cover_photo, content_types: AttachmentLimits::IMAGES, max_size: 5.megabytes
end
