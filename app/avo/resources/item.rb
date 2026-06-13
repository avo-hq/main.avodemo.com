class Avo::Resources::Item < Avo::BaseResource
  self.model_class = "Avo::Kanban::Item"
  self.icon = "heroicons/outline/squares-2x2"
  self.description = "Demo resource for the polymorphic avo-kanban items that place any allowed record into a board column."
  self.visible_on_sidebar = false

  def fields
    field :id, as: :id
    field :record, as: :belongs_to, polymorphic_as: :record, types: view&.form? ? record.board.allowed_models : nil
    field :position, as: :number
    field :board, as: :belongs_to
    field :column, as: :belongs_to
  end
end
