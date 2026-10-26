# The demo is public and its uploads land in our S3 bucket, so each attachment
# says what it takes and how big. The browser's `accept:` hint is all there was
# before, and anyone can post around that.
module AttachmentLimits
  extend ActiveSupport::Concern

  IMAGES = %w[image/png image/jpeg image/gif image/webp].freeze
  AUDIO = %w[audio/mpeg audio/mp4 audio/x-m4a audio/ogg audio/wav audio/x-wav audio/webm].freeze
  DOCUMENTS = %w[application/pdf text/plain application/msword application/vnd.openxmlformats-officedocument.wordprocessingml.document].freeze

  # The direct-upload endpoint checks against these before handing out an S3
  # URL, so it can't be used to park something no field would accept.
  ALL_TYPES = (IMAGES + AUDIO + DOCUMENTS).freeze
  MAX_SIZE = 20.megabytes

  class_methods do
    def limit_attachment(name, content_types:, max_size:)
      validate do
        attached = public_send(name)
        blobs = attached.respond_to?(:blobs) ? attached.blobs : [attached.blob].compact

        blobs.each do |blob|
          unless content_types.include?(blob.content_type)
            errors.add(name, "#{blob.filename} isn't an accepted file type")
          end
          if blob.byte_size > max_size
            errors.add(name, "#{blob.filename} is over #{ActiveSupport::NumberHelper.number_to_human_size(max_size)}")
          end
        end
      end
    end
  end
end
