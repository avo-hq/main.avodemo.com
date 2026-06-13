class Avo::Resources::Issue < Avo::BaseResource
  self.title = :name
  self.icon = "tabler/outline/circle-dot"
  self.description = "Demo Kanban-enabled resource (avo-kanban) that renders rich, GitHub-style cards via a custom item component."

  self.search = {
    query: -> {
      query.ransack(id_eq: params[:q], title_cont: params[:q], body_cont: params[:q], m: "or").result(distinct: false)
    }
  }

  # Render this resource's kanban cards with the rich, GitHub-style component by
  # overriding the gem's default card via Avo's `self.components`.
  self.components = {
    "Avo::Kanban::Items::ItemComponent" => "Avo::Kanban::Items::WorkItemComponent"
  }

  def fields
    field :id, as: :id, link_to_record: true
    field :number, as: :number, sortable: true
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
      options: ::Issue::STATUSES.index_by(&:itself),
      hide_on: :display,
      include_blank: "No status"
    field :priority,
      as: :badge,
      options: {
        neutral: "Low",
        info: "Medium",
        warning: "High",
        danger: "Urgent"
      },
      filterable: true
    field :priority,
      as: :select,
      options: ::Issue::PRIORITIES.index_by(&:itself),
      hide_on: :display,
      include_blank: true
    field :author, as: :text
    field :body, as: :textarea, hide_on: :index
  end
end
