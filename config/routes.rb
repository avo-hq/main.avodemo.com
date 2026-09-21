Rails.application.routes.draw do
  devise_for :users
  root to: redirect("/avo")

  get "hey", to: "home#hey"

  post "/reset", to: "home#reset"

  # REST API (avo-api). Mounted OUTSIDE the `authenticate` block on purpose — it
  # carries its own auth, accepting either a bearer token or HTTP Basic (see
  # Avo::Api::Resources::V1::BaseResourcesController), and is consumed by the
  # Avo::Resources::HttpUser HTTP resource, which sends the Basic pair.
  #
  # That controller is the ONLY thing between these endpoints and the open
  # internet. It is covered by test/integration/avo_api_authentication_test.rb;
  # keep it that way.
  mount_avo_api

  # MCP server (avo-mcp_server). Also OUTSIDE the `authenticate` block, and before
  # `mount_avo`: AI clients call the token and JSON-RPC endpoints with a bearer
  # token and no browser session, and the two OAuth discovery documents live at
  # the origin root. Both misplacements are refused at boot. The consent screen
  # and the MCP connections resource are part of the panel and use Devise as usual.
  mount_avo_mcp_server

  authenticate :user, ->(user) { user.admin? } do
    mount_avo do
      get "welcome", to: "tools#welcome"
      get "custom_page", to: "tools#custom_page"

      scope :resources do
        get "courses/cities", to: "courses#cities"
      end
    end

    # Solid Queue dashboard. Gated twice on purpose: this Devise constraint, and
    # FlightdeckBaseController's own before_actions. The constraint alone is not
    # enough — Flightdeck answers 401 until it is told how to authenticate.
    mount Flightdeck::Engine, at: "/jobs"
  end
  # scope ":course", constraints: {course: /\w+(-\w+)*/} do
  #   scope ":locale", constraints: {locale: /\w[-\w]*/} do
  #     get "hey", to: "home#hey"
  #     mount Avo::Engine, at: Avo.configuration.root_path
  #   end
  # end

  get :checkcheckcheck, to: "home#check"
  get "up" => "health#show", as: :rails_health_check
end
