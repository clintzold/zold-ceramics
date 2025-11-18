Rails.application.routes.draw do
  devise_for :users
  # Admin routes
  get "admin", to: "admin#dashboard"

  get "home", to: "pages#home"
  get "about", to: "pages#about"

  # Products routes
  get "shop", to: "products#shop"
  get "products/:id", to: "products#show"

  # Cart routes
  resource :cart, only: [ :show ] do
    post "add_item/:product_id", to: "carts#add_item", as: :add_item
    delete "remove_item/:product_id", to: "carts#remove_item", as: :remove_item
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  root "pages#home"
end
