Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  devise_for :users,
             path: "api/users",
             controllers: {
               sessions: "api/users/sessions",
               registrations: "api/users/registrations"
             }

  namespace :api do
    delete "logout", to: "users/sessions#destroy"
    get "dashboard", to: "dashboard#dashboard"
    get "roles", to: "roles#roles_index"
    get "profile", to: "users#profile"
    get "orders", to: "orders#order_index"
    get "active_client_orders", to: "orders#active_client_orders"
    get "finished_client_orders", to: "orders#finished_client_orders"
    post "roles", to: "roles#create"
    post "create_order", to: "orders#create_order"

  end


end

