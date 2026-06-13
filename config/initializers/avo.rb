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
  config.explicit_authorization = true
  config.current_user_method = :current_user
  config.click_row_to_view_record = true
  # Read the app name from a cookie so the Settings → App Settings form can change
  # it live (the form writes cookies[:app_name]). Falls back to the default name.
  config.app_name = -> { request.cookies["app_name"] || "Avo Demo" }

  config.main_menu = -> {
    section I18n.t("avo.dashboards"), icon: "app/assets/images/demo-adjustments.svg" do
      dashboard :dashy, visible: -> { true }

      # Direct link to the seeded "Engineering board" kanban view. Built as a plain
      # path string (matching the other links in this menu) because the menu block
      # isn't a full routing context, so engine route helpers can't resolve here.
      if (engineering_board = Avo::Kanban::Board.find_by(name: "Engineering board"))
        link_to "Engineering board", "#{Avo.configuration.root_path}/boards/#{engineering_board.id}", icon: "avo/square-kanban"
      end

      group "All dashboards", visible: false, collapsable: true do
        all_dashboards
      end
    end

    section "Config", icon: "cog" do
      page Avo::Pages::Settings, icon: "adjustments-vertical"
    end

    section "API", icon: "heroicons/outline/key" do
      resource :http_user
      resource :author
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

      # comment for now until we merge https://github.com/avo-hq/avo-menu/pull/59
      # resource :issues do
      #   resource :pull_requests
      #   resource :tasks
      #   resource :boards
      # end

      # end
      group "Engineering", collapsable: true do
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
      link_to "Avo", "https://avohq.io", target: :_blank
      link_to "Google", "https://google.com", target: :_blank
    end
  }
  config.profile_menu = -> {
    link_to "Dashboard", "/avo/dashboards/dashy", icon: "user-circle"
    link_to "See Avo 3 version", "https://avo-3.avodemo.com", target: :_blank
  }
  config.header_menu = -> {
    # Shows the live app name (same cookie source as config.app_name above), so it
    # updates when you change the name in Settings → App Settings.
    link_to (request.cookies["app_name"] || "Avo Demo"), Avo.configuration.root_path
    link_to 'Avo HQ', 'https://avohq.io', target: :_blank
    link_to 'Source code', 'https://github.com/avo-hq/avodemo', target: :_blank
    link_to 'Documentation', 'https://docs.avohq.io/4.0', target: :_blank
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
