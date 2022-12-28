Rails.application.routes.draw do
  devise_for :users
  root to: redirect('/avo')

  get "hey", to: "home#hey"

  post "/reset", to: "home#reset"

  mount Avo::Engine => Avo.configuration.root_path, :constraints => UserConstraint.new
  # authenticate :user, -> user { user.admin? } do
  # end

  get :checkcheckcheck, to: "home#check"
end

if defined? ::Avo
  Avo::Engine.routes.draw do
    get 'custom_page', to: "tools#custom_page"

    scope :resources do
      get "courses/cities", to: "courses#cities"
    end
  end
end
