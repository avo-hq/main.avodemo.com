class Avo::Resources::Team < Avo::BaseResource
  self.title = :name
  self.includes = [:admin, :team_members]
  self.search = {
    query: -> do
      query.ransack(id_eq: params[:q], name_cont: params[:q], m: "or").result(distinct: false)
    end
  }

  self.grid_view = {
    card: -> {
      cover_url = if record.url.present?
        "//logo.clearbit.com/#{URI.parse(record.url).host}?size=180"
      end

      {
        title: record.name,
        cover_url:,
        body: record.url
      }
    }
  }

  def fields
    field :preview, as: :preview
    field :id, as: :id, filterable: true
    field :name, as: :text, sortable: true, show_on: :preview, filterable: true
    field :logo, as: :external_image,hide_on: :show, as_avatar: :rounded do
      if record.url
        "//logo.clearbit.com/#{URI.parse(record.url).host}?size=180"
      end
    end
    field :description,
      as_description: true,
      as: :textarea,
      rows: 5,
      readonly: false,
      hide_on: :index,
      filterable: true,
      format_using: -> { value.to_s.truncate 30 },
      default: "This is a wonderful team!",
      nullable: true,
      null_values: ["0", "", "null", "nil"],
      show_on: :preview

    field :created_at, as: :date_time, filterable: true
    field :members_count, as: :number do
      record.team_members.length
    end

    field :admin, as: :has_one
    field :team_members, as: :has_many, through: :memberships
    field :memberships,
      as: :has_many,
      searchable: true,
      filterable: true,
      attach_scope: -> do
        query.where.not(user_id: parent.id).or(query.where(user_id: nil))
      end
    field :reviews, as: :has_many

    sidebar do
      field :url, as: :text, translation_key: "avo.field_translations.team_url"
      field :created_at, as: :date_time, hide_on: :forms
      field :logo, as: :external_image, as_avatar: :rounded do
        if record.url
          "//logo.clearbit.com/#{URI.parse(record.url).host}?size=180"
        end
      end
    end
  end

  def filters
    filter Avo::Filters::Name
  end

  def actions
    action Avo::Actions::Dummy
  end
end
