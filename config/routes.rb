Rails.application.routes.draw do
  resources :lists, except: [ :show ] do
    resources :tasks
  end
  root to: "lists#index"
end
