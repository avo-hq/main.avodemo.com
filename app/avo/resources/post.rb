module Avo
  module Resources
    class Post < Resource
      def initialize
        @title = :name
        @search = [:name, :id]
        @includes = :user
        @default_view_type = :grid
      end

      fields do
        id
        text :name, required: true
        trix :body, placeholder: 'Enter text', always_show: false
        textarea :body, hide_on: [:show, :edit], format_using: -> (value) { ActionView::Base.full_sanitizer.sanitize(value).truncate 120 }
        file :cover_photo, is_image: true
        boolean :is_featured
        boolean :is_published do |model|
          model.published_at.present?
        end

        heading '<div class="text-gray-300 uppercase font-bold">DEV</div>', as_html: true
        code :custom_css, theme: 'dracula', language: 'css', help: "This enables you to edit the user's custom styles."

        belongs_to :user, searchable: false, placeholder: '—'
      end

      # These fields are a reference on the already configured fields above
      grid do
        preview :cover_photo
        title :name
        body :body
      end

      use_filter Avo::Filters::FeaturedFilter
      use_filter Avo::Filters::PublishedFilter

      use_action Avo::Actions::TogglePublished
    end
  end
end
