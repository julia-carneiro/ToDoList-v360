Rails.application.routes.draw do
  resource :session
  resources :passwords, param: :token
  resources :lists, except: [ :show ] do
    resources :tasks
  end
  root to: "lists#index"
end
