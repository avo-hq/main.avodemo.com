class CourseResource < Avo::BaseResource
  self.title = :name
  self.includes = []
  self.description = 'Demo resource to illustrate Avo\'s nested (namespaced) model support (Course has_many Course::Link)'
  self.search_query = ->(params:) do
    scope.ransack(id_eq: params[:q], name_cont: params[:q], m: "or").result(distinct: false)
  end

  field :id, as: :id
  field :name, as: :text
  field :link, as: :has_many
end
