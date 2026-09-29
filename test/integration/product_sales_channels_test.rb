require "test_helper"

# The Product resource carries the demo's one `as: :select, multiple: true`
# field (`sales_channels`, backed by a Postgres string array). These requests
# prove the field round-trips through Avo: the edit form renders a multi-select
# with the stored picks selected, saving keeps the picks as an array and drops
# the blank a multi-select form always submits, and Show prints the option
# labels rather than the stored values.
class ProductSalesChannelsTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  # https on purpose, matching the other integration tests: plain http is
  # refused outside localhost.
  ORIGIN = "https://main.avodemo.com".freeze

  setup do
    user = User.create!(
      first_name: "Demo",
      last_name: "Admin",
      email: "sales-channels-#{SecureRandom.hex(4)}@example.com",
      password: "secreto123",
      # `mount_avo` sits inside `authenticate :user, ->(user) { user.admin? }`,
      # so a non-admin gets a RoutingError (404), not the panel.
      roles: {"admin" => true}
    )
    sign_in user

    @product = Product.create!(title: "iPod", category: "Music players", price_cents: 19_900, price_currency: "USD")
  end

  test "edit renders a multi-select with the stored picks selected" do
    @product.update!(sales_channels: %w[online retail])

    get "#{ORIGIN}/avo/resources/products/#{@product.id}/edit"

    assert_response :success
    assert_select "select[name='product[sales_channels][]'][multiple]" do
      assert_select "option[value='online'][selected]"
      assert_select "option[value='retail'][selected]"
      assert_select "option[value='wholesale']:not([selected])"
    end
  end

  test "update stores the picks as an array and drops the blank the form submits" do
    patch "#{ORIGIN}/avo/resources/products/#{@product.id}",
      params: {product: {sales_channels: ["", "online", "wholesale"]}}

    assert_response :redirect
    assert_equal %w[online wholesale], @product.reload.sales_channels
  end

  test "show prints the labels of the stored values" do
    @product.update!(sales_channels: %w[online marketplace])

    get "#{ORIGIN}/avo/resources/products/#{@product.id}"

    assert_response :success
    assert_includes response.body, "Online store, Marketplace"
  end
end
