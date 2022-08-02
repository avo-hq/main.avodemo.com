class PostResource < Avo::BaseResource
  self.title = :name
  self.search_query = ->(params:) do
    scope.ransack(id_eq: params[:q], name_cont: params[:q], body_cont: params[:q], m: "or").result(distinct: false)
  end
  self.search_query_help = "- search by id, name or body"
  self.includes = [:user]
  self.default_view_type = :grid

  field :id, as: :id
  field :name, as: :text, required: true, sortable: true
  field :body,
    as: :trix,
    placeholder: "Enter text",
    always_show: false,
    attachment_key: :trix_attachments,
    hide_attachment_url: true,
    hide_attachment_filename: true,
    hide_attachment_filesize: true
  field :tags,
    as: :tags,
    # readonly: true,
    acts_as_taggable_on: :tags,
    close_on_select: false,
    placeholder: "add some tags",
    suggestions: -> { Post.tags_suggestions },
    enforce_suggestions: true,
    help: "The only allowed values here are `one`, `two`, and `three`"
  field :cover_photo, as: :file, is_image: true, as_avatar: :rounded, hide_on: [:index], full_width: true, accept: "image/*"
  field :cdn_cover_photo, as: :external_image, name: 'Cover photo', required: true, only_on: [:index], link_to_resource: true, as_avatar: :rounded
  field :audio, as: :file, is_audio: true, accept: "audio/*"
  field :excerpt, as: :text, hide_on: :all, as_description: true do |model|
    ActionView::Base.full_sanitizer.sanitize(model.body).truncate 130
  rescue
    ""
  end

  field :is_featured, as: :boolean, visible: -> (resource:) { context[:user].admin? }
  field :is_published, as: :boolean do |model|
    model.published_at.present?
  end
  heading '<div class="text-gray-300 uppercase font-bold">DEV</div>', as_html: true
  field :user, as: :belongs_to, meta: { searchable: false }, placeholder: '—'
  field :custom_css, as: :code, theme: 'dracula', language: 'css', help: "This enables you to edit the user's custom styles."

  field :status, as: :select, enum: ::Post.statuses

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
