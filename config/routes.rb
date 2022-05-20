Rails.application.routes.draw do
  devise_for :users
  root to: redirect('/avo')

  post '/reset', to: 'home#reset'

  authenticate :user, -> user { user.admin? } do
    mount Avo::Engine => Avo.configuration.root_path
  end
end

if defined? ::Avo
  Avo::Engine.routes.draw do
    get 'custom_page', to: "tools#custom_page"
  end
end