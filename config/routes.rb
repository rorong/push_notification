Rails.application.routes.draw do
  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'push_notifications#new'
  post '/send_message', to: 'push_notifications#send_message'

  namespace :api do
    namespace :v1 do
      resources :users
    end
  end
end
