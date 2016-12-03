Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'pages#index'
  namespace :api, defaults: {format: :json} do
    resources :tweets, only: [:create]
  end
  resources :legislators, only: [:index, :create]
  resources :logins
  get '/unsubscribe' => 'pages#show'
end
