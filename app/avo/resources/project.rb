class Avo::Resources::Project < Avo::BaseResource
  self.title = :name
  self.search = {
    query: -> do
      query.ransack(id_eq: params[:q], name_cont: params[:q], country_cont: params[:q], m: "or").result(distinct: false)
    end
  }
  self.includes = [:users]
  self.attachments = [:files]

  self.discreet_information = [
    :timestamps,
    :id_badge,
    {
      tooltip: -> { sanitize("View <strong>#{record.name}</strong> on site", tags: %w[strong]) },
      icon: -> { "heroicons/outline/arrow-top-right-on-square" },
      url: -> { main_app.root_url },
      url_target: :_blank,
      # as: :badge
    }
  ]

  def fields
    field :id, as: :id, link_to_record: true
    field :name, as: :text, required: true, as_label: true, sortable: true
    field :progress, as: :progress_bar, value_suffix: "%", display_value: true
    field :stage,
      as: :select,
      hide_on: [:show, :index],
      enum: ::Project.stages,
      placeholder: "Choose the stage",
      display_value: true,
      include_blank: false,
      filterable: true
    field :stage, as: :badge, options: {info: ["Discovery", "Idea"], success: "Done", warning: "On hold", danger: "Cancelled"}, summarizable: true
    field :status, as: :status, failed_when: [:closed, :rejected, :failed], loading_when: [:loading, :running, :waiting], nullable: true, filterable: true, summarizable: true
    field :country,
      as: :country,
      filterable: true,
      index_text_align: :left,
      include_blank: "No country"
    field :users_required, as: :number, min: 10, max: 1000000, step: 1, index_text_align: :right
    field :started_at, as: :date_time, name: "Started", time_24hr: true, relative: true, timezone: "EET", nullable: true
    field :description, as: :markdown, height: "350px"
    field :files, as: :files, translation_key: "avo.field_translations.file", is_image: true, direct_upload: true
    field :meta, as: :key_value, key_label: "Meta key", value_label: "Meta value", action_text: "New item", delete_text: "Remove item", disable_editing_keys: false, disable_adding_rows: false, disable_deleting_rows: false

    field :users, as: :has_and_belongs_to_many
    field :comments, as: :has_many
    field :reviews, as: :has_many
  end

  def actions
    action Avo::Actions::ExportCsv
  end
end
