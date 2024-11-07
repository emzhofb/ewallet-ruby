Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"
  post 'auth/register', to: 'auth#register'
  post 'auth/login', to: 'auth#login'
  post 'auth/refresh', to: 'auth#refresh'  # refresh token endpoint
  
  namespace :api do
    namespace :v1 do
      post "transfers/create", to: 'transfers#create'
      get "accounts", to: 'accounts#index'
      post 'accounts/create', to: 'accounts#create'
      get "accounts/:id", to: 'accounts#show'
      post "accounts/:id/update_balance", to: 'accounts#update_balance'
    end
  end

  # Catch-all route for API that matches unmatched paths
  match '*path', to: 'application#route_not_found', via: :all
end
 