module Avo
  module Api
    module Resources
      module V1
        # Array records have no save!/destroy!, so the writes go to BookmarkStore
        # here, as they do in the panel's Avo::BookmarksController.
        class BookmarksController < BaseResourcesController
          private

          # Fetching builds the model class with an accessor per attribute, so a new record can be filled.
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
      end
    end
  end
end
