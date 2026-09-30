require "test_helper"

# Bookmark is an ArrayResource with writes: the controller saves to
# BookmarkStore, a JSON file. One test on purpose, since parallel workers
# would share that file.
class BookmarksArrayResourceTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  ORIGIN = "https://main.avodemo.com".freeze

  setup do
    BookmarkStore::PATH.delete if BookmarkStore::PATH.exist?

    sign_in @user = User.create!(
      first_name: "Demo",
      last_name: "Admin",
      email: "bookmarks-#{SecureRandom.hex(4)}@example.com",
      password: "secreto123",
      roles: {"admin" => true}
    )
  end

  teardown { BookmarkStore::PATH.delete if BookmarkStore::PATH.exist? }

  test "reads, creates, updates and deletes bookmarks in the panel and over the API" do
    get "#{ORIGIN}/avo/resources/bookmarks"
    assert_response :success
    assert_includes response.body, "Avo docs"
    assert_select "a[href='/avo/resources/bookmarks/new']"

    get "#{ORIGIN}/avo/resources/bookmarks/new"
    assert_response :success

    post "#{ORIGIN}/avo/resources/bookmarks", params: {bookmark: {title: "Hotwire", url: "https://hotwired.dev"}}
    assert_redirected_to "#{ORIGIN}/avo/resources/bookmarks/4"
    assert_equal({id: 4, title: "Hotwire", url: "https://hotwired.dev"}, BookmarkStore.all.last)

    get "#{ORIGIN}/avo/resources/bookmarks/4/edit"
    assert_response :success
    assert_select "form[action='/avo/resources/bookmarks/4'] input[name='_method'][value='put']"
    assert_select "input[name='bookmark[title]'][value='Hotwire']"

    patch "#{ORIGIN}/avo/resources/bookmarks/4", params: {bookmark: {title: "Hotwire!"}}
    assert_redirected_to "#{ORIGIN}/avo/resources/bookmarks/4"
    assert_equal "Hotwire!", BookmarkStore.all.last[:title]

    get "#{ORIGIN}/avo/resources/bookmarks/4"
    assert_response :success
    assert_includes response.body, "Hotwire!"

    delete "#{ORIGIN}/avo/resources/bookmarks/4"
    assert_equal [1, 2, 3], BookmarkStore.all.map { _1[:id] }

    # The same round trip over avo-api, which answers 404 to every request when unlicensed.
    skip "The API half needs AVO_LICENSE_KEY" if ENV["AVO_LICENSE_KEY"].blank?

    api = "#{ORIGIN}/api/resources/v1/bookmarks"
    token, secret = Avo::Api::Token.generate(name: "Bookmarks", owner: @user)
    token.save!
    headers = {"Authorization" => "Bearer #{secret}"}

    get api, headers: headers
    assert_response :success
    assert_equal ["Avo", "Avo docs", "Ruby on Rails"], response.parsed_body["records"].map { _1["title"] }

    post api, params: {bookmark: {title: "Turbo", url: "https://turbo.hotwired.dev"}}, headers: headers, as: :json
    assert_response :created
    assert_equal({"id" => 4, "title" => "Turbo", "url" => "https://turbo.hotwired.dev"}, response.parsed_body["record"])

    patch "#{api}/4", params: {bookmark: {title: "Turbo!"}}, headers: headers, as: :json
    assert_response :success
    assert_equal "Turbo!", BookmarkStore.all.last[:title]

    get "#{api}/4", headers: headers
    assert_equal "Turbo!", response.parsed_body.dig("record", "title")

    delete "#{api}/4", headers: headers
    assert_response :success
    assert_equal [1, 2, 3], BookmarkStore.all.map { _1[:id] }
  end
end
