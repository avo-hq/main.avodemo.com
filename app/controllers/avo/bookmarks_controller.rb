# Array records have no save!/destroy!, so the writes go to BookmarkStore here.
class Avo::BookmarksController < Avo::ArrayController
  private

  def save_record_action
    @record.id = BookmarkStore.save(id: @record.id&.to_i, title: @record.title, url: @record.url)
  end

  def destroy_record_action
    BookmarkStore.destroy(@record.id)
  end
end
