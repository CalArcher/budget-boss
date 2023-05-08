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


 

# client = Twilio::REST::Client.new(ENV['ACCOUNT_SID'], ENV['AUTH_TOKEN'])

# from = ENV['TWILIO_NUMBER']
# to = ENV['CAL_NUMBER'] 

# client.messages.create(
#   from: from,
#   to: to,
#   body: "Good Test"
# )

