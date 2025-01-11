Rails.application.routes.draw do
  resources :users, only: [ :new, :create ] # Rotas para sign up
  resource :session, only: [ :new, :create, :destroy ] # Rotas para login/logout
  resources :confirmations, only: [ :edit ]

  resources :passwords, param: :token
  resources :lists, except: [ :show ] do
    resources :tasks
  end
  root to: "lists#index"
end
