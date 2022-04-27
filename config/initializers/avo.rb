Avo.configure do |config|
  config.root_path = '/avo'
  config.license = 'pro'
  config.license_key = ENV['AVO_LICENSE_KEY']
  config.id_links_to_resource = true
  config.home_path = '/avo/dashboards/dashy'
  config.set_context do
    {
      foo: 'bar',
      user: current_user,
      params: request.params,
    }
  end
  config.current_user_method = :current_user

  config.main_menu = -> {
    section I18n.t("avo.dashboards"), icon: "dashboards" do
      dashboard :dashy, visible: -> { true }

      group "All dashboards", visible: false, collapsable: true do
        all_dashboards
      end
    end

    section "Resources", icon: "heroicons/outline/academic-cap", collapsable: true, collapsed: false do
      group "Academia", collapsable: true do
        resource :course
        resource :course_link
      end

      group "Blog", collapsable: true do
        resource :posts
        resource :comments
      end

      group "Company" do
        resource :projects
        resource :team
        resource :reviews
      end

      group "People", collapsable: true do
        resource "UserResource"
        resource :people
        resource :spouses
      end

      group "Other", collapsable: true, collapsed: true do
        resource :fish
      end
    end

    section "Tools", icon: "heroicons/outline/finger-print", collapsable: true, collapsed: true do
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
