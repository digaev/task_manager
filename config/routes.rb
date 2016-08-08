Rails.application.routes.draw do
  scope module: :web do
    root to: 'welcome#index'

    resources :users
  end
end
