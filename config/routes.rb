Rails.application.routes.draw do
  # Webhook resources and job trigger for Stripe activity
  post "webhooks", to: "webhooks#create"
  # User authentication/sign-up/accounts
  devise_for :users
  # Admin routes
  get "admin", to: "admin#dashboard"
  # Visitor routes
  get "home", to: "pages#home"
  get "about", to: "pages#about"
  # Products routes
  resources :products, only: [ :new, :create, :edit, :index, :destroy ]
  get "shop", to: "products#shop"
  get "products/:id", to: "products#show"
  patch "products/:id", to: "products#update"
  # Cart routes
  resource :cart, only: [ :show ] do
    post "add_item/:product_id", to: "carts#add_item", as: :add_item
    delete "remove_item/:product_id", to: "carts#remove_item", as: :remove_item
  end
  # Payments with Stripe
  post "checkout_session_create", to: "checkout#create"
  get "checkout", to: "checkout#new"
  get "checkout/success", to: "checkout#success"

  # Shipping controller routes(Shippo API)
  post "shipping", to: "shipping#get_shipping_options"
  get "shipping", to: "shipping#test"
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
