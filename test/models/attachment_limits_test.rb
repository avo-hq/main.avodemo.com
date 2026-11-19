require "test_helper"

class AttachmentLimitsTest < ActiveSupport::TestCase
  def upload(bytes:, content_type:, filename: "file")
    {io: StringIO.new("x" * bytes), filename: filename, content_type: content_type, identify: false}
  end

  test "takes an image within the limit" do
    product = Product.new(title: "Pod")
    product.image.attach(upload(bytes: 1.kilobyte, content_type: "image/png"))

    assert product.valid?, product.errors.full_messages.to_sentence
  end

  test "refuses an image over the limit" do
    product = Product.new(title: "Pod")
    product.image.attach(upload(bytes: 5.megabytes + 1, content_type: "image/png", filename: "big.png"))

    refute product.valid?
    assert_includes product.errors[:image].join, "big.png is over 5 MB"
  end

  test "refuses a file type the field doesn't take, in a has_many attachment too" do
    product = Product.new(title: "Pod")
    product.images.attach(upload(bytes: 1.kilobyte, content_type: "image/png"))
    product.images.attach(upload(bytes: 1.kilobyte, content_type: "text/html", filename: "page.html"))

    refute product.valid?
    assert_includes product.errors[:images].join, "page.html isn't an accepted file type"
  end
end
