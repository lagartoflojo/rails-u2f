Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  get '/login' => 'sessions#new'
  post '/login' => 'sessions#create'
  delete '/logout' => 'sessions#destroy'

  resources :users
  resources :devices, only: [:index, :new, :create, :destroy]
  resource :device_authentication, controller: 'device_authentication', only: [:new, :create]

  root to: 'sessions#new'
end
