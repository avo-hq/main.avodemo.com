class Avo::Resources::Column < Avo::BaseResource
  self.model_class = "Avo::Kanban::Column"
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
