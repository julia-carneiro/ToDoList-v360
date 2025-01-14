Rails.application.routes.draw do
  resources :users, only: [ :new, :create ] # Routes to sign up
  resource :session, only: [ :new, :create, :destroy ] # Routes to login/logout

  resources :passwords, param: :token
  resources :lists, except: [ :show ] do
    resources :tasks
  end

  root to: "lists#index"

  # This is used in the confirmation e-mail - gets the route confirm/token (sent by mailer)
  # and redirect it to cofirmations/edit (defined in confirmation_controller)
  get "confirm/:token", to: "confirmations#edit", as: :edit_confirmation

  # Captures any routes that aren't defined and redirect it to #not_found (defined in aplication_controller)
  match "*path", to: "application#not_found", via: :all
end
