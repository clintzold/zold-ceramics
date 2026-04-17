Rails.application.routes.draw do
  resource :session
  resources :passwords, param: :token

  # Contact Forms (no database model)
  get "contacts/new"
  get "contacts/create"

  # Webhook resources and job trigger for Stripe activity
  post "webhooks", to: "webhooks#create"

  # Visitor routes
  get "home", to: "pages#home"
  get "about", to: "pages#about"
  get "shop", to: "pages#shop"

  # Products routes

  # Order routes
  resources :orders, only: [ :create ]

  # Shipments routes
  resources :shipments, only: [ :create, :index, :show ]

  # Subscriptions
  resources :subscriptions, only: [:index, :new, :create]
  get "subscriptions/cancel", to: "subscriptions#destroy", as: :cancel_subscription

  namespace :admin do
    root to: "dashboard#index"
    # Products
    resources :products, only: [ :new, :create, :edit, :index, :destroy ]
    get "products/:id", to: "products#show"
    patch "products/:id", to: "products#update"

    #Orders
    get "orders/filter", to: "orders#filter", as: :filter_orders
    resources :orders, only: [:index, :show]

    # Pickups
    resources :pickups, only: [:new, :create, :index, :show]
    get "pickups/cancel", to: "pickups#destroy", as: :cancel_pickup

    # Charts
    get "charts/orders", to: "charts#orders", as: :charts_orders
    get "charts/products", to: "charts#products", as: :charts_products
    get "charts/filter", to: "charts#filter", as: :charts_filter
  end

  # Cart routes
  resource :cart, only: [ :show ] do
    post "add_item/:product_id", to: "carts#add_item", as: :add_item
    delete "remove_item/:product_id", to: "carts#remove_item", as: :remove_item
  end

  # Payments with Stripe
  get "checkout", to: "checkout#new"
  get "checkout/success", to: "checkout#success"

  # Shipping controller routes(Shippo API)
  post "shipping_options", to: "shipping_options#create"

  # Contact Forms controller(Handles 'Contact Us' submissions)
  resources :contact_forms, only: [ :new, :create ]
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
