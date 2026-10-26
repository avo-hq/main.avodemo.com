# Rails' direct-upload endpoint hands anyone a presigned S3 URL for a blob of
# any type and size, signed in or not. On a public demo that's free storage.
# Only signed-in users get one, and only for files some field would accept.
Rails.application.config.to_prepare do
  ActiveStorage::DirectUploadsController.class_eval do
    before_action :authenticate_user!
    before_action :refuse_unacceptable_upload

    private

    def refuse_unacceptable_upload
      blob = params.require(:blob)
      return if AttachmentLimits::ALL_TYPES.include?(blob[:content_type]) && blob[:byte_size].to_i <= AttachmentLimits::MAX_SIZE

      render json: {error: "That file type or size isn't accepted here."}, status: :unprocessable_content
    end
  end
end
