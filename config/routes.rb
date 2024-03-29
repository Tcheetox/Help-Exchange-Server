Rails.application.routes.draw do
  
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  # As we don’t need the app authorization, we can skip the authorizations and authorized_applications controller
  # We can also skip the applications controller, as users won’t be able to create or delete OAuth application
  devise_for :users, only: []

  Rails.application.routes.draw do

    scope(path: '/fishforhelp') do
      use_doorkeeper scope: 'api/v1/oauth' do
        skip_controllers :authorizations, :applications, :authorized_applications, :token_info
      end

      namespace :api do
        namespace :v1 do
          match '/oauth/sso', to: 'single_sign_on#create', via: %i[post]

          resources :users, only: [:create]
          match '/users', to: 'users#show', via: %i[get]
          match '/users', to: 'users#destroy', via: %i[delete]
          match '/users', to: 'users#update', via: %i[put]
          match '/users/:subaction', to: 'users#update_without_password', via: %i[put]
          match '/users/storage', to: 'users_storage#create', via: %i[post]
          match '/users/mailer/:subaction', to: 'users_mailer#create', via: %i[post]

          resources :help_requests, only: [:create, :index]
          match '/help_requests/:id/:subaction', to: 'help_requests#update', via: %i[put]
          match '/help_requests/filter', to: 'help_requests#filter', via: %i[get]

          mount ActionCable.server => '/cable/:token'
          resources :conversations, only: [:index, :create, :show]

          resources :faq, only: [:index]
        end
      end
    end

  end 
end
