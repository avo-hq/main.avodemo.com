class PostResource < Avo::BaseResource
  self.title = :name
  self.search = [:name, :id]
  self.includes = :user
  self.default_view_type = :grid

  fields do |f|
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

  grid do |cover, title, body|
    cover.external_image :cdn_cover_photo, required: true, link_to_resource: true
    title.text :name, required: true, link_to_resource: true
    body.text :excerpt do |model|
      begin
        ActionView::Base.full_sanitizer.sanitize(model.body).truncate 120
      rescue => exception
        ''
      end
    end
  end

  filters do |f|
    f.use FeaturedFilter
    f.use PublishedFilter
  end

  actions do |a|
    a.use TogglePublished
  end
end
