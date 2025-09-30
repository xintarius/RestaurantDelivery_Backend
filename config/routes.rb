Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  devise_for :users,
             path: "api/users",
             controllers: {
               sessions: "api/users/sessions",
               registrations: "api/users/registrations"
             }

  namespace :api do
    get "dashboard", to: "dashboard#dashboard"
    get "roles", to: "roles#roles_index"
    post "roles", to: "roles#create"
    get "profile", to: 'users#profile'
  end


end

