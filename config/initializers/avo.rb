Avo.configure do |config|
  config.root_path = '/avo'
  config.license_key = ENV['AVO_LICENSE_KEY']
  config.id_links_to_resource = true
  # config.home_path = -> () { avo.dashboard_path('dashy') }
  # config.home_path = -> (controller) { avo.dashboard_path('dashy') }
  config.home_path = '/avo/dashboards/dashy'
  config.resource_controls_placement = :right
  # config.branding = {
  #   colors: {
  #     # BLUE
  #     100 => "#CEE7F8",
  #     400 => "#399EE5",
  #     500 => "#0886DE",
  #     600 => "#066BB2",
  #     # RED
  #     100 => "#FACDD4",
  #     400 => "#F06A7D",
  #     500 => "#EB3851",
  #     600 => "#E60626",
  #     # GREEN
  #     100 => "#C5F1D4",
  #     400 => "#3CD070",
  #     500 => "#30A65A",
  #     600 => "#247D43",
  #     # PURPLE
  #     100 => "#e9d5ff",
  #     400 => "#c084fc",
  #     500 => "#a855f7",
  #     600 => "#9333ea",
  #     # ORANGE
  #     100 => "#FFECCC",
  #     400 => "#FFB435",
  #     500 => "#FFA102",
  #     600 => "#CC8102",
  #   },
  #   logo: "/avo-assets/logo.png",
  #   logomark: "/avo-assets/logomark.png"
  # }

  config.set_context do
    {
      foo: 'bar',
      user: current_user,
      params: request.params,
      account: Current.account
    }
  end
  config.current_user_method = :current_user

  config.main_menu = -> {
    section I18n.t("avo.dashboards"), icon: "app/assets/images/demo-adjustments.svg" do
      dashboard :dashy, visible: -> { true }

      group "All dashboards", visible: false, collapsable: true do
        all_dashboards
      end
    end

    section "Resources", icon: "academic-cap.svg", collapsable: true, collapsed: false do
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
      end
    end

    section "Tools", icon: "heroicons/outline/finger-print", collapsable: true, collapsed: false do
      all_tools
    end

    group do
      link "Avo", path: "https://avohq.io"
      link "Google", path: "https://google.com", target: :_blank
    end
  }
  config.profile_menu = -> {
    link "Dashboard", path: "/avo/dashboards/dashy", icon: "user-circle"
  }
end

if defined?(AvoFilters)
  AvoFilters.configure do |config|
    config.button_label = "Advanced filters"
    config.always_expanded = true
  end
end
