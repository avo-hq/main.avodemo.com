Rails.application.routes.draw do
  devise_for :users
  root to: redirect("/avo")

  get "hey", to: "home#hey"

  post "/reset", to: "home#reset"

  # REST API (avo-api). Mounted OUTSIDE the `authenticate` block on purpose — it
  # carries its own HTTP Basic auth (see Avo::Api::Resources::V1::BaseResourcesController)
  # and is consumed by the Avo::Resources::HttpUser HTTP resource.
  mount_avo_api

  authenticate :user, ->(user) { user.admin? } do
    mount_avo
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

if defined? ::Avo
  Avo::Engine.routes.draw do
    get "custom_page", to: "tools#custom_page"

    scope :resources do
      get "courses/cities", to: "courses#cities"
    end
  end
end
