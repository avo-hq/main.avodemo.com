class Avo::Resources::Membership < Avo::BaseResource
  self.title = :name
  self.includes = [:user, :team]
  self.visible_on_sidebar = false
  self.search = {
    query: -> do
      query.ransack(id_eq: params[:q], m: "or").result(distinct: false)
    end,
    hide_on_global: true
  }
  self.model_class = "TeamMembership"

  def fields
    field :id, as: :id
    field :id, as: :number, only_on: :edit

    field :level, as: :select, as_description: true, options: -> {
      {Beginner: :beginner, Intermediate: :intermediate, Advanced: :advanced, "#{record.id}": "model_id", "#{resource.name}": "resource_name", "#{view}": "view", "#{field.id}": "field"}
    }, display_value: false, default: -> { (Time.now.hour < 12) ? "advanced" : "beginner" }

    field :user, as: :belongs_to, searchable: false, attach_scope: -> {
      # puts ["parent->", parent, parent.team].inspect
      query
    }
    field :team, as: :belongs_to
  end
end
