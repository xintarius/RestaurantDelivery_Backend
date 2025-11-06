Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  devise_for :users,
             path: "api/users",
             controllers: {
               sessions: "api/users/sessions",
               registrations: "api/users/registrations"
             }

  devise_scope :user do
    post "/api/vendor_register", to: "api/users/registrations#vendor_register"
  end

  namespace :api do
    delete "logout", to: "users/sessions#destroy"
    get "dashboard", to: "dashboard#dashboard"

    get "roles", to: "roles#roles_index"
    post "roles", to: "roles#create"

    get "profile", to: "users#profile"

    get "orders", to: "orders#order_index"
    get "client_menu", to: "orders#client_menu"
    post "create_order_from_cart", to: "orders#create_order_from_cart"

    get "active_client_orders", to: "orders#active_client_orders"
    get "finished_client_orders", to: "orders#finished_client_orders"

    get "vendors", to: "vendors#vendors"

    get "courier_interface", to: "courier#courier_interface"

    post "create_product", to: "products#create_product"
    post "add_to_cart", to: "cart_summaries#add_to_cart"

    get "cart_summary", to: "cart_summaries#cart_summary"

    post "user_payment", to: "payments#user_payment"

    namespace :v1 do
    get "earnings/courier/:id", to: "billing#earnings"
    end
  end
end

