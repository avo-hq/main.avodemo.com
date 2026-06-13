class Avo::Resources::Board < Avo::BaseResource
  self.model_class = "Avo::Kanban::Board"

  self.edit_controls = -> {
    if record.persisted?
      link_to "Visit board", avo_kanban.board_path(record), color: :primary, style: :primary, icon: "avo/square-kanban"
    end
    default_controls
  }

  self.show_controls = -> {
    link_to "Visit board", avo_kanban.board_path(record), color: :primary, style: :primary, icon: "avo/square-kanban"
    default_controls
  }

  self.row_controls = -> {
    link_to "Visit board", avo_kanban.board_path(record), color: :gray
    default_controls
  }

  def fields
    field :id, as: :id
    field :name, as: :text
    field :description, as: :textarea
    field :allowed_resources, as: :text, format_using: -> { value.join(", ") }, hide_on: :forms
    field :property, as: :text
    field :full_width_container, as: :boolean
    field :exclude_duplicates,
      as: :boolean,
      help: "When enabled, items that are already present in the board will be excluded from the search results."
    field :allowed_resources, as: :tags, suggestions: -> { Avo.resource_manager.resources.map(&:to_s) }
    field :columns_count, as: :number, hide_on: :forms
    field :items_count, as: :number, hide_on: :forms

    field :columns, as: :has_many
  end
end
