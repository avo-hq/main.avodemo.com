require "test_helper"

class DirectUploadLimitsTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  def direct_upload(content_type:, byte_size:)
    post rails_direct_uploads_path, as: :json, params: {
      blob: {filename: "file", content_type: content_type, byte_size: byte_size, checksum: Digest::MD5.base64digest("x")}
    }
  end

  test "hands no upload URL to a visitor who isn't signed in" do
    direct_upload(content_type: "image/png", byte_size: 1.kilobyte)

    assert_response :unauthorized
  end

  test "hands a signed-in user an upload URL only for files some field takes" do
    sign_in User.create!(first_name: "A", last_name: "B", email: "a@example.com", password: "secreto")

    direct_upload(content_type: "image/png", byte_size: 1.kilobyte)
    assert_response :success

    direct_upload(content_type: "application/x-msdownload", byte_size: 1.kilobyte)
    assert_response :unprocessable_content

    direct_upload(content_type: "image/png", byte_size: AttachmentLimits::MAX_SIZE + 1)
    assert_response :unprocessable_content
  end
end
