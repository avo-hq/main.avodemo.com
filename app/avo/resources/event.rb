class Avo::Resources::Event < Avo::BaseResource
  self.hotkey = "r e"
  self.icon = "heroicons/outline/calendar-days"
  self.description = -> {
    if record.present?
      "An event that happened at a certain time."
    else
      "This resource type has avatar and cover photos attached to it."
    end
  }

  self.cover = {
    # size: :xl,
    visible_on: [:show, :index],
    source: -> {
      if record.present?
        record.cover_photo
      # else
      #   Event.first&.cover_photo
      end
    }
  }
  self.avatar = {
    source: :profile_photo
  }
  self.discreet_information = :timestamps

  self.row_controls_config = {
    float: true,
    show_on_hover: true,
    placement: :right
  }

  def fields
    field :profile_photo, as: :avatar
    field :name, as: :text, link_to_record: true, sortable: true, stacked: true
    field :event_time, as: :date_time, sortable: true

    with_options as: :file, is_image: true, only_on: :forms do
      field :profile_photo
      field :cover_photo
    end
  end
end
