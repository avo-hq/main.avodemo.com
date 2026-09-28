# Array records have no save!/destroy!, so the writes go to BookmarkStore here.
class Avo::BookmarksController < Avo::ArrayController
  private

  # Builds the Avo::Bookmark class with its accessors before `new` instantiates it.
  def set_record_to_fill
    @resource.fetch_records
    super
  end

  def save_record_action
    @record.id = BookmarkStore.save(id: @record.id&.to_i, title: @record.title, url: @record.url)
  end

  def destroy_record_action
    BookmarkStore.destroy(@record.id)
  end
end
