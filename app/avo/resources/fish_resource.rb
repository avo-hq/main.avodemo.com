class FishResource < Avo::BaseResource
  self.title = :name
  self.includes = []
  self.description = 'Demo resource to illustrate Avo\'s support for uncountable models (the model represented here is Fish)'
  self.search_query = ->(params:) do
    scope.ransack(id_eq: params[:q], name_cont: params[:q], m: "or").result(distinct: false)
  end

  field :id, as: :id
  field :name, as: :text

  action DummyAction
end
