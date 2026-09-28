require "test_helper"

# Bookmark is an ArrayResource with writes: the controller saves to
# BookmarkStore, a JSON file. One test on purpose, since parallel workers
# would share that file.
class BookmarksArrayResourceTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  ORIGIN = "https://main.avodemo.com".freeze

  setup do
    BookmarkStore::PATH.delete if BookmarkStore::PATH.exist?

    sign_in User.create!(
      first_name: "Demo",
      last_name: "Admin",
      email: "bookmarks-#{SecureRandom.hex(4)}@example.com",
      password: "secreto123",
      roles: {"admin" => true}
    )
  end

  teardown { BookmarkStore::PATH.delete if BookmarkStore::PATH.exist? }

  test "reads, creates, updates and deletes bookmarks" do
    get "#{ORIGIN}/avo/resources/bookmarks"
    assert_response :success
    assert_includes response.body, "Avo docs"

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
  end
end
