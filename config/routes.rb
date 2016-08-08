Rails.application.routes.draw do
  scope module: :web do
    root to: 'welcome#index'

    resources :users, only: [:new, :create] do
      scope module: :users do
        resources :tasks
      end
    end
  end
end
