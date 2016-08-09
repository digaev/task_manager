Rails.application.routes.draw do
  scope module: :web do
    root to: 'tasks#index'

    resources :users, only: [:new, :create] do
      scope module: :users do
        resources :tasks
      end
    end

    resources :sessions, only: [:new, :create]
  end
end
