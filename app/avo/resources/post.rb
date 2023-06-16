class Avo::Resources::Post < Avo::BaseResource
  self.title = :name
  self.search = {
    query: -> do
      query.ransack(id_eq: params[:q], name_cont: params[:q], body_cont: params[:q], m: "or").result(distinct: false)
    end,
    help: "- search by id, name or body"
  }
  self.includes = [:user]
  self.default_view_type = :grid

  self.grid_view = {
    card: -> {
      body = begin
        ActionView::Base.full_sanitizer.sanitize(record.body).truncate 130
      rescue
        ""
      end
      {
        title: record.name,
        cover_url: record.cdn_cover_photo,
        body:
      }
    }
  }

  def fields
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
    field :excerpt, as: :text, hide_on: :all, as_description: true do
      ActionView::Base.full_sanitizer.sanitize(record.body).truncate 130
    rescue
      ""
    end

    field :is_featured, as: :boolean, visible: -> { context[:user].admin? }
    field :is_published, as: :boolean do
      record.published_at.present?
    end
    heading '<div class="text-gray-300 uppercase font-bold">DEV</div>', as_html: true
    field :user, as: :belongs_to, meta: { searchable: false }, placeholder: '—'

    field :status, as: :select, enum: ::Post.statuses

    field :comments, as: :has_many
  end

  def filters
    filter Avo::Filters::Featured
    filter Avo::Filters::Published
  end

  def actions
    action Avo::Actions::TogglePublished
  end
end
