Avo.configure do |config|
  config.root_path = '/avo'
  config.license_key = ENV['AVO_LICENSE_KEY']
  config.id_links_to_resource = true
  config.home_path = -> { "/avo/dashboards/dashy" }
  # Avo 4: `config.branding` was renamed to `config.appearance`. The flat `colors:`
  # hash was removed in favor of an accent preset (`accent: :blue`) or a custom
  # accent palette via `accent_colors: { color:, content:, foreground: }`.
  config.appearance = {
    logo: "/img/logo.png",
  #   logomark: "/avo-assets/logomark.png",
  #   accent: :brand,
  #   accent_colors: {
  #     color: "#0886DE",
  #     content: "#066BB2",
  #     foreground: "#FFFFFF"
  #   }
  }
  config.exclude_from_status = ["license_key"]
  config.set_context do
    {
      foo: 'bar',
      user: current_user,
      params: request.params,
      account: Current.account
    }
  end
  config.current_user_method = :current_user
  config.click_row_to_view_record = true

  config.main_menu = -> {
    section I18n.t("avo.dashboards"), icon: "app/assets/images/demo-adjustments.svg" do
      dashboard :dashy, visible: -> { true }

      group "All dashboards", visible: false, collapsable: true do
        all_dashboards
      end
    end

    section "Resources", icon: "tabler/outline/school", collapsable: true, collapsed: false do
      group "Company", collapsable: true do
        resource :projects
        resource :team, visible: -> {
          authorize current_user, Team, "index?", raise_exception: false
        }
        resource :team_membership, visible: -> {
          authorize current_user, TeamMembership, "index?", raise_exception: false

          false
        }
        resource :reviews
        resource :city
        resource :products
      end

      group "People", collapsable: true do
        # resource "UserResource", visible: -> do

        # end
        # authorize current_user, User, "index?", raise_exception: false
        resource "User"
        resource :people
        resource :spouses
      end

      group "Education", collapsable: true do
        resource :course
        resource :course_link
      end

      group "Blog", collapsable: true do
        resource :posts
        resource :comments
      end

      group "Other", collapsable: true, collapsed: true do
        resource :fish, label: "Fishies"
        resource :movie
        resource :event
      end
    end

    section "Tools", icon: "tabler/outline/fingerprint", collapsable: true, collapsed: false do
      all_tools
    end

    link_to "Media Library", avo.media_library_index_path

    group do
      link "Avo", path: "https://avohq.io"
      link "Google", path: "https://google.com", target: :_blank
    end
  }
  config.profile_menu = -> {
    link "Dashboard", path: "/avo/dashboards/dashy", icon: "user-circle"
    link "See Avo 3 version", path: "https://avo-3.avodemo.com", target: :_blank
  }
  config.header_menu = -> {
    link_to 'Avo HQ', path: 'https://avohq.io', target: :_blank
    link_to 'Source code', path: 'https://github.com/avo-hq/avodemo', target: :_blank
    link_to 'Documentation', path: 'https://docs.avohq.io', target: :_blank
  }
end

if defined?(Avo::DynamicFilters)
  Avo::DynamicFilters.configure do |config|
    config.button_label = "Advanced filters"
    config.always_expanded = true
  end
end

if defined?(Avo::MediaLibrary)
  Avo::MediaLibrary.configure do |config|
    config.enabled = true
  end
end
