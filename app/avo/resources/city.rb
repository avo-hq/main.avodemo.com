class Avo::Resources::City < Avo::BaseResource
  self.includes = []
  self.search = {
    query: -> { query.ransack(id_eq: params[:q], m: "or").result(distinct: false) }
  }
  self.extra_params = [city: [:name, :metadata, :coordinates, :city_center_area, :description, :population, :is_capital, :image_url, :tiny_description, features: {}, metadata: {}]]
  self.default_view_type = :map
  self.map_view = {
    mapkick_options: {
      controls: true
    },
    record_marker: -> {
      {
        latitude: record.latitude,
        longitude: record.longitude,
        tooltip: record.name
      }
    },
    table: {
      visible: true,
      layout: :bottom
    }
  }

  def fields
    field :id, as: :id
    field :name, as: :text
    field :population, as: :number
    field :is_capital, as: :boolean
    field :features, as: :code
    field :metadata, as: :code
    field :image_url, as: :text
    field :tiny_description, as: :textarea
    field :longitude, as: :number
    field :latitude, as: :number
    field :city_center_area, as: :code
  end
end
