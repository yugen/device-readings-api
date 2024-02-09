Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.

  post "/device-readings", to: "device_readings#store"
  get "/device-readings/:id", to: "device_readings#show"
  get "/device-readings/:id/latest-timestamp", to: "device_readings#latest_timestamp"
  get "/device-readings/:id/cumulative-count", to: "device_readings#cumulative"
end
