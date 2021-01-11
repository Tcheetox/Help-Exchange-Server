Rails.application.routes.draw do
  use_doorkeeper
  devise_for :users
  resources :requests
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root 'requests#index'

  # As we don’t need the app authorization, we can skip the authorizations and authorized_applications controller
  # We can also skip the applications controller, as users won’t be able to create or delete OAuth application
  Rails.application.routes.draw do
    use_doorkeeper do
      skip_controllers :authorizations, :applications, :authorized_applications
    end

    namespace :api do
      namespace :v1 do
        resources :requests, only: [:index, :show, :update, :destroy]
        resources :users, only: [:index, :show, :update, :destroy, :create]
      end
    end

  end
  
end
