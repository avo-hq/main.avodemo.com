class PostResource < Avo::BaseResource
  self.title = :name
  self.search_query = ->(params:) do
    scope.ransack(id_eq: params[:q], name_cont: params[:q], m: "or").result(distinct: false)
  end
  self.includes = :user
  self.default_view_type = :grid

  field :id, as: :id
  field :name, as: :text, required: true
  field :status, as: :select, enum: ::Post.statuses
  field :body, as: :trix, placeholder: 'Enter text', always_show: false, attachment_key: :trix_attachments
  field :cover_photo, as: :file, is_image: true, hide_on: [:index]
  field :cdn_cover_photo, as: :external_image, name: 'Cover photo', required: true, only_on: [:index], link_to_resource: true, as_avatar: :rounded
  field :is_featured, as: :boolean, visible: -> (resource:) { context[:user].admin? }
  field :is_published, as: :boolean do |model|
    model.published_at.present?
  end
  heading '<div class="text-gray-300 uppercase font-bold">DEV</div>', as_html: true
  field :user, as: :belongs_to, meta: { searchable: false }, placeholder: '—'
  field :custom_css, as: :code, theme: 'dracula', language: 'css', help: "This enables you to edit the user's custom styles."

  field :comments, as: :has_many

  grid do
    cover :cover_photo, as: :file, is_image: true, link_to_resource: true
    # cover :cdn_cover_photo, as: :external_image, link_to_resource: true
    title :name, as: :text, required: true, link_to_resource: true
    body :excerpt, as: :text do |model|
      begin
        ActionView::Base.full_sanitizer.sanitize(model.body).truncate 130
      rescue => exception
        ''
      end
    end
  end

  filter FeaturedFilter
  filter PublishedFilter

  action TogglePublished
end
