class Avo::Actions::PreUpdate < Avo::BaseAction
  self.name = "Update"
  # self.visible = -> do
  #   true
  # end

  def fields
    field :name, as: :boolean
    field :population, as: :boolean
  end

  def handle(**args)
    arguments = {
      cities: args[:query].map(&:id),
      render_name: args[:fields][:name],
      render_population: args[:fields][:population]
    }
    navigate_to_action Avo::Actions::Update, arguments:
  end
end
