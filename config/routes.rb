Rails.application.routes.draw do
  resources :bills
  resources :sheets
  resources :text_sends
  resources :text_recieves
  resources :transactions 

  get "/healthcheck", to: proc { [200, {}, ["OK"]] }

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end