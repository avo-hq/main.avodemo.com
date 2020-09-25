Rails.application.routes.draw do
  devise_for :users
  root to: redirect('/avo')

  authenticate :user, -> user { user.admin? } do
    mount Avo::Engine => Avo.configuration.root_path
  end
end
