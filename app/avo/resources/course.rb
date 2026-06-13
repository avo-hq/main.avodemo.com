class Avo::Resources::Course < Avo::BaseResource
  self.hotkey = "r c"
  self.icon = "heroicons/outline/book-open"
  self.title = :name
  self.includes = []
  self.description = "Demo resource to illustrate Avo's nested (namespaced) model support (Course has_many Course::Link)"
  self.search = {
    query: -> do
      query.ransack(id_eq: params[:q], name_cont: params[:q], m: "or").result(distinct: false)
    end
  }
  self.keep_filters_panel_open = true
  self.stimulus_controllers = "course-resource toggle-fields"

  # Collaboration (avo-collaboration): records an activity timeline with comments
  # and reactions, plus automatic "watcher" entries when watched properties change.
  self.collaboration = {
    author: {
      current_author: -> { current_user },
      name_property: :name,
    },
    watchers: [
      {
        property: :name,
        message: -> { "This property has been updated #{property}: #{old_value} -> #{new_value}" }
      },
      {
        property: :country,
        i18n_message_key: "avo.collaboration.country_changed_html",
      },
      {
        property: :city,
      }
    ],
  }

  def fields
    field :id, as: :id
    field :name, as: :text, html: {
      edit: {
        input: {
          # classes: "bg-primary-500",
          data: {
            action: "input->resource-edit#debugOnInput"
          }
        },
        wrapper: {
          # style: "background: red;",
        }
      }
    }
    field :has_skills, as: :boolean, filterable: true, html: -> do
      edit do
        input do
          # classes('block')
          data({
            # foo: record,
            # resource: resource,
            action: "input->resource-edit#toggle",
            resource_edit_toggle_target_param: "skills_tags_wrapper",
            # resource_edit_toggle_targets_param: ["country_select_wrapper"]
          })
        end
      end
    end
    field :skills,
      as: :tags,
      disallowed: -> { record.skill_disallowed },
      suggestions: -> { record.skill_suggestions },
      filterable: {
        suggestions: ["example suggestion", "example tag"]
      },
      html: -> do
      edit do
        wrapper do
          classes do
            unless record.has_skills
              "hidden"
            end
          end
          # classes: "hidden"
        end
      end
    end
    field :country,
      as: :select, filterable: true,
      options: Course.countries.map { |country| [country, country] }.prepend(["-", nil]).to_h
    # `react_on: :country` (avo-reactive_fields) re-renders this field server-side
    # whenever the country select changes, narrowing the city options to that
    # country — no custom Stimulus needed (replaces the old onCountryChange handler).
    field :city,
      as: :select,
      react_on: :country,
      options: -> { (Course.cities.dig(@record.country&.to_sym) || [""]).map { |city| [city, city] }.to_h },
      display_value: false
    field :links,
      as: :has_many,
      searchable: true,
      placeholder: "Click to choose a link",
      discreet_pagination: true,
      linkable: true,
      nested: true,
      filterable: {
        query_attributes: [:links_link]
      }

    collaboration_timeline
  end

  def filters
    filter Avo::Filters::CourseCountry
    filter Avo::Filters::CourseCity
  end
end
