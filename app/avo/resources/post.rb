module Avo
  module Resources
    class Post < Resource
      def configure
        @title = :name
        @search = [:name, :id]
        @includes = :user
        @default_view_type = :grid
      end

      def fields(request)
        f.id
        f.text :name, required: true
        f.trix :body, placeholder: 'Enter text', always_show: false
        f.textarea :body, hide_on: [:show, :edit]
        f.file :cover_photo, is_image: true, hide_on: [:index]
        f.external_image :cdn_cover_photo, name: 'Cover photo', required: true, only_on: [:index], link_to_resource: true
        f.boolean :is_featured
        f.boolean :is_published do |model|
          model.published_at.present?
        end

        f.heading '<div class="text-gray-300 uppercase font-bold">DEV</div>', as_html: true
        f.code :custom_css, theme: 'dracula', language: 'css', help: "This enables you to edit the user's custom styles."

        f.belongs_to :user, searchable: false, placeholder: '—'
      end

      def grid(request)
        g.external_image :cdn_cover_photo, required: true, grid_position: :preview, link_to_resource: true
        g.text :name, required: true, grid_position: :title, link_to_resource: true
        g.text :excerpt, grid_position: :body do |model|
          begin
            ActionView::Base.full_sanitizer.sanitize(model.body).truncate 120
          rescue => exception
            ''
          end
        end
      end

      def filters(request)
        filter.use Avo::Filters::FeaturedFilter
        filter.use Avo::Filters::PublishedFilter
      end

      def actions(request)
        a.use Avo::Actions::TogglePublished
      end
    end
  end
end
