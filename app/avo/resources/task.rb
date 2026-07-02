class Avo::Resources::Task < Avo::BaseResource
  self.title = :name
  self.icon = "heroicons/outline/clipboard-document-check"
  self.description = "Demo Kanban-enabled resource (avo-kanban) using a custom item component for rich board cards."

  self.search = {
    query: -> {
      query.ransack(id_eq: params[:q], title_cont: params[:q], description_cont: params[:q], m: "or").result(distinct: false)
    }
  }

  # Render this resource's kanban cards with the rich, GitHub-style component by
  # overriding the gem's default card via Avo's `self.components`.
  self.components = {
    "Avo::Kanban::Items::ItemComponent" => "Avo::Kanban::Items::WorkItemComponent"
  }

  def fields
    field :id, as: :id, link_to_record: true
    field :title, as: :text, required: true, sortable: true, link_to_record: true
    field :status,
      as: :badge,
      options: {
        info: ["Backlog", "In Review"],
        warning: ["Todo", "In Progress"],
        success: "Done"
      },
      filterable: true,
      sortable: true
    field :status,
      as: :select,
      options: ::Task::STATUSES.index_by(&:itself),
      hide_on: :display,
      include_blank: "No status"
    field :completed, as: :boolean
    field :assignee, as: :text
    field :due_on, as: :date, sortable: true
    field :description, as: :textarea, hide_on: :index
  end
end
