require "test_helper"

# Every visitor edits these records through one shared login, so their text has to reach the page escaped or
# sanitized, the way Avo's own Tiptap show field already treats the product description.
class RecordTextInHtmlTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  # https on purpose, matching the other integration tests: plain http is refused outside localhost.
  ORIGIN = "https://main.avodemo.com".freeze

  setup do
    sign_in User.create!(
      first_name: "Demo",
      last_name: "Admin",
      email: "record-text-#{SecureRandom.hex(4)}@example.com",
      password: "secreto123",
      roles: {"admin" => true}
    )
  end

  test "the product grid card keeps the description's formatting and drops event handlers" do
    Product.create!(title: "iPod", description: %(<p><strong>Pocket</strong> music</p><img src="x" onerror="alert(1)">))

    get "#{ORIGIN}/avo/resources/products?view_type=grid"

    assert_response :success
    assert_select ".grid-card__description strong", text: "Pocket"
    assert_select ".grid-card__description img[onerror]", count: 0
  end

  test "the person link shows the name as text" do
    Person.create!(name: %(<b onmouseover="alert(1)">Ann</b>))

    get "#{ORIGIN}/avo/resources/people"

    assert_response :success
    assert_select "td[data-field-id='link'] a[href='https://avohq.io']", text: %(<b onmouseover="alert(1)">Ann</b>)
    assert_select "td[data-field-id='link'] b[onmouseover]", count: 0
  end
end
