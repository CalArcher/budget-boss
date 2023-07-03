Rails.application.routes.draw do
  resources :bills
  resources :sheets
  resources :transactions 

  post '/receive_text', to: 'twilio#receive_text'
  get "/healthcheck", to: proc { [200, {}, ["OK"]] }
  get "*path", to: "catch_all#catch_all"


  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end