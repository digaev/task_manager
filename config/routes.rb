Rails.application.routes.draw do
  scope module: :web do
    root to: 'tasks#index'

    resources :users, only: [:new, :create] do
      scope module: :users do
        resources :tasks, only: [:index]
      end
    end

    resources :tasks do
      match '/change_state/:state',
        action: :change_state,
        as: :change_state,
        via: [:patch, :put],
        on: :member
    end

    resources :sessions, only: [:new, :create] do
      delete :destroy, on: :collection
    end
  end
end
