Rails.application.routes.draw do
  resources :users, only: [ :new, :create, :show ] # Rotas para sign up
  resource :session, only: [ :new, :create, :destroy ] # Rotas para login/logout

  resources :passwords, param: :token
  resources :lists, except: [ :show ] do
    resources :tasks
  end
  root to: "lists#index"
end
