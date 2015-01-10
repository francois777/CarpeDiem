Rails.application.routes.draw do

  resources :sessions, only: [:new, :create, :destroy]
  resources :events, only: [:index, :show]
  resources :reservation_requests, only: [:new, :create, :edit, :update, :show] do
    member do
      post :submit
    end
  end

  post "admin/versions/:id/revert" => "admin/versions#revert", :as => "revert_version"

  namespace :admin do
    resources :users
    resources :accommodation_types do
      resources :tariffs
    end    
    resources :events, only: [:new, :create, :edit, :update, :destroy]
    resources :chalets
    resources :camping_sites
    resources :tents, controller: 'camping_sites', type: 'Tent'
    resources :caravans, controller: 'camping_sites', type: 'Caravan'
    resources :reservations, only: [:show]
    resources :reservation_requests, only: [:index, :show] do
      member do
        get :decline
        get :accept
      end
    end
  end

  root 'static_pages#home'
  match '/admin/camping_sites/gettents', to: 'admin/camping_sites#gettents', via: 'get'
  get '/home', to: 'static_pages#home'
  get '/facilities', to: 'static_pages#facilities'
  get '/tariffs', to: 'tariffs#summary'
  get '/events', to: 'events#index'
  get '/directions', to: 'static_pages#directions'
  get '/accommodation', to: 'static_pages#accommodation'
  get '/activities', to: 'static_pages#activities'
  get '/memories', to: 'static_pages#memories'
  get '/views', to: 'static_pages#views'
  get '/test', to: 'static_pages#test'
  get '/afrikaans', to: 'users#to_afrikaans'
  get '/english', to: 'users#to_english'

  get "/signin",  to: "sessions#new"
  match "/signout", to: "sessions#destroy", via: 'get'
  post "/signin", to: "sessions#create"
  delete "/signout", to: "sessions#destroy"

  get "change_password", to: "users#change_password"
  get "password_reset", to: "users#password_reset"
  get "forgot_password", to: "users#forgot_password"
  post "allocate_password" => "users#allocate_password"
  put "password_reset" => "users#new_password"

  get "password_sent", to: "authentication#password_sent"

  get "account_settings" => "users#account_settings"
  put "account_settings" => "users#set_account_info"  

end
