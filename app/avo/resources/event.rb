class Avo::Resources::Event < Avo::BaseResource
  self.description = "An event that happened at a certain time."

  self.cover_photo = {
    # size: :sm,
    visible_on: [:show, :index],
    source: -> {
      if record.present?
        record.cover_photo
      else
        Event.first&.cover_photo
      end
    }
  }
  self.profile_photo = {
    source: :profile_photo
  }
  self.discreet_information = :timestamps

  self.row_controls_config = {
    float: true,
    show_on_hover: true,
    placement: :both
  }

  def fields
    field :name, as: :text, link_to_record: true, sortable: true, stacked: true
    field :event_time, as: :date_time, sortable: true

    with_options as: :file, is_image: true, only_on: :forms do
      field :profile_photo
      field :cover_photo
    end
  end
end
