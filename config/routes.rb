Rails.application.routes.draw do
  scope :avo do
    get "dashboard", to: "avo/tools#dashboard"
  end
  devise_for :users
  root to: redirect('/avo')

  post '/reset', to: 'home#reset'

  authenticate :user, -> user { user.admin? } do
    mount Avo::Engine => Avo.configuration.root_path
  end
end
