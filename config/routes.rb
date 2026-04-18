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

    get "vendor_orders", to: "orders#vendor_orders"
    put "accept/:id", to: "orders#accept"
    put "reject/:id", to: "orders#reject"
    put "ready/:id", to: "orders#ready"
    get "client_menu/:vendor_id", to: "orders#client_menu"
    post "create_order_from_cart", to: "orders#create_order_from_cart"

    get "active_client_orders", to: "orders#active_client_orders"
    get "finished_client_orders", to: "orders#finished_client_orders"

    # vendor routes
    get "vendors", to: "vendors#vendors"
    get "get_products", to: "products#get_products"
    get "limitations", to: "limitations#index"
    get "statistics", to: "statistics#statistics"
    post "limitations", to: "limitations#set_limit"
    get "vendors/show_availablity", to: "vendors#show_availability"
    post "vendors/update_status", to: "vendors#update_status"
    post "vendors/update_standard_hours", to: "vendors#update_standard_hours"
    post "vendors/sync_exceptions", to: "vendors#sync_exceptions"

    # courier routes
    get "courier_interface", to: "courier#courier_interface"
    get "courier_profile", to: "courier#courier_profile"
    get "history_data", to: "courier#history_data"
    get "courier_wallet", to: "courier#courier_wallet"

    post "create_product", to: "products#create_product"
    put "/update_product/:id", to: "products#update_product"
    delete "delete_product/:id", to: "products#delete_product"
    post "add_to_cart", to: "cart_summaries#add_to_cart"

    get "cart_summary", to: "cart_summaries#cart_summary"
    get "get_cart_sum", to: "cart_summaries#get_cart_sum"
    post "user_payment", to: "payments#user_payment"

    get "get_address", to: "addresses#get_address"

    get "get_notification", to: "notifications#get_notification"

    get "courier_ticket", to: "support_tickets#courier_ticket"
    get "show_courier_ticket_details/:id", to: "support_tickets#show_courier_ticket_details"
    post "create_courier_ticket", to: "support_tickets#create_courier_ticket"

    get "category_types", to: "category_types#category"
    get "category_types/:category_id/vendors", to: "category_types#find_category"
    delete "cart_products/:id", to: "cart_summaries#cart_products"
    namespace :v1 do
    get "earnings/courier/:id", to: "billing#earnings"
    end
  end

  mount ActionCable.server => "/cable"
end

