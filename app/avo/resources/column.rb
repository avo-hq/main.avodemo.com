class Avo::Resources::Column < Avo::BaseResource
  self.model_class = "Avo::Kanban::Column"
  self.icon = "heroicons/outline/view-columns"
  self.description = "Demo resource for the columns that make up an avo-kanban board, reorderable with drag-and-drop."
  self.visible_on_sidebar = false

  self.ordering = {
    visible_on: :association,
    display_inline: true,
    drag_and_drop: true,
    actions: {
      insert_at: -> { record.insert_at position },
    }
  }

  def fields
    field :id, as: :id
    field :name, as: :text
    field :position, as: :number, hide_on: :forms
    field :value, as: :text
    field :items_count, as: :number, hide_on: :forms
    field :board, as: :belongs_to
    field :items, as: :has_many
  end
end
