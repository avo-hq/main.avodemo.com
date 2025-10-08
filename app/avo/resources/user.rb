class Avo::Resources::User < Avo::BaseResource
  self.title = :name
  self.description = -> {
    "Users of the app. view: #{view}"
  }
  self.translation_key = "avo.resource_translations.user"
  self.search = {
    query: -> {
      query.order(created_at: :desc).ransack(id_eq: params[:q], first_name_cont: params[:q], last_name_cont: params[:q], m: "or").result(distinct: false)
    },
    item: -> {
      {
        title: "[#{record.id}] #{record.name}",
        description: record.email,
        image_url: record.gravatar,
        image_format: :circular
      }
    }
  }
  self.find_record_method = -> do
    query.friendly.find id
  end
  self.includes = [:posts, :post]
  self.attachments = [:cv]
  self.single_includes = [:post]
  self.devise_password_optional = true

  self.grid_view = {
    card: -> {
      {
        title: record.name,
        cover_url: record.gravatar,
        body: record.email
      }
    }
  }

  self.profile_photo = {
    source: -> {
      record.gravatar
    }
  }

  def fields
    main_panel do
      field :id, as: :id, link_to_record: true
      field :email, as: :gravatar, link_to_record: true, as_avatar: :circle, only_on: :index
      field :user_information, as: :heading
      field :first_name, as: :text, placeholder: "John", stacked: true, filterable: true
      field :last_name, as: :text, placeholder: "Doe", filterable: true
      field :email, as: :text, name: "User Email", required: true, protocol: :mailto, filterable: true
      field :active, as: :boolean, name: "Is active", only_on: :index, filterable: true
      field :cv, as: :file, name: "CV"
      field :is_admin?, as: :boolean, name: "Is admin", only_on: :index, filterable: true
      field :level,
        format_using: -> do
          record.memberships.find_by(user_id: record.id, team_id: Team.find(params[:id]))&.level
        end,
        visible: -> do
          resource.view.index? && params[:resource_name] == 'teams'
        end
      # computed field to demo the some fields
      field :status, as: :status, failed_when: [:closed, :rejected, :failed], loading_when: [:loading, :running, :waiting] do
        [:closed, :rejected, :failed, :loading, :running, :waiting].sample
      end
      field :user_status, as: :badge, options: {success: "Active", warning: "Inactive", danger: "Banned"} do
        ["Active", "Inactive", "Banned"].sample
      end
      field :progress, as: :progress_bar do
        rand(100)
      end
      field :roles, as: :boolean_group, options: {admin: "Administrator", manager: "Manager", writer: "Writer"}
      field :roles, as: :text, hide_on: :all do
        "This user has the following roles: #{record.roles.select { |key, value| value }.keys.join(", ")}"
      end
      field :birthday,
        as: :date,
        first_day_of_week: 1,
        picker_format: "F J Y",
        format: "cccc, d LLLL yyyy", # Wednesday, 10 February 1988
        placeholder: "Feb 24th 1955",
        required: true,
        only_on: [:index],
        filterable: true

      field :is_writer, as: :text,
        sortable: -> {
          # Order by something else completely, just to make a test case that clearly and reliably does what we want.
          query.order(id: direction)
        },
        hide_on: :edit do
          (record.posts.to_a.size > 0) ? "yes" : "no"
        end

      field :password, as: :password, name: "User Password", required: false, except_on: :forms, help: 'You may verify the password strength <a href="http://www.passwordmeter.com/" target="_blank">here</a>.'
      field :password_confirmation, as: :password, name: "Password confirmation", required: false, only_on: :new

      field :dev, as: :heading, label: '<div class="underline uppercase font-bold">DEV</div>', as_html: true
      field :team_id, as: :hidden, default: 0 # For testing purposes

      sidebar do
        field :email, as: :gravatar, link_to_record: true, as_avatar: :circle, only_on: :show
        field :heading, as: :heading, label: ""
        field :active, as: :boolean, name: "Is active"
        field :is_admin?, as: :boolean, name: "Is admin", only_on: :index
        field :birthday,
          as: :date,
          first_day_of_week: 1,
          picker_format: "F J Y",
          format: "cccc, d LLLL yyyy", # Wednesday, 10 February 1988
          placeholder: "Feb 24th 1955",
          required: true,
          only_on: [:show]
        field :is_writer, as: :text,
          hide_on: :edit do
            (record.posts.to_a.size > 0) ? "yes" : "no"
          end
        field :outside_link, as: :text, only_on: [:show], format_using: -> { link_to("hey", value, target: "_blank") } do
          main_app.hey_url
        end
        field :custom_css, as: :code, theme: "dracula", language: "css", help: "This enables you to edit the user's custom styles.", height: "250px"
      end
    end

    return if params.dig(:turbo_frame) == "has_one_field_show_admin"

    tabs id: :tabs do
      tab "Birthday", description: "hey you", hide_on: :show do
        panel do
          field :birthday,
            as: :date,
            first_day_of_week: 1,
            picker_format: "F J Y",
            format: "DDDD",
            placeholder: "Feb 24th 1955",
            required: true,
            default: Date.current
        end
      end

      field :teams, as: :has_and_belongs_to_many
      field :people,
        as: :has_many,
        show_on: :edit,
        translation_key: "avo.field_translations.people"
      field :spouses, as: :has_many # STI has_many resource
      field :projects, as: :has_and_belongs_to_many
    end

    tabs id: :tabs_2 do
      field :post,
        as: :has_one,
        name: "Main post",
        translation_key: "avo.field_translations.people"
      field :posts,
        as: :has_many,
        show_on: :edit,
        attach_scope: -> { query.where.not(user_id: parent.id).or(query.where(user_id: nil)) }
      field :comments,
        as: :has_many,
        # show_on: :edit,
        scope: -> { query.starts_with parent.first_name[0].downcase },
        description: "The comments listed in the attach modal all start with the name of the parent user."
    end

    tool Avo::ResourceTools::UserTool
  end

  def actions
    action Avo::Actions::Dummy
  end

  def filters
    filter Avo::Filters::Active
    filter Avo::Filters::IsAdmin
    filter Avo::Filters::DummyMultipleSelect
    filter Avo::Filters::UserNames
    filter Avo::Filters::Birthday
  end

  def scopes
    scope Avo::Scopes::Admins
    scope Avo::Scopes::NonAdmins
    scope Avo::Scopes::Active
  end

  def cards
    return if params.dig(:related_name).present?

    card Avo::Cards::ExampleAreaChart, cols: 3
    card Avo::Cards::ExampleMetric, cols: 2
    card Avo::Cards::ExampleMetric,
      label: "Active users metric",
      description: "Count of the active users.",
      arguments: { active_users: true },
      visible: -> { !resource.view.form? }
  end
end
