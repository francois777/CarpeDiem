Rails.application.routes.draw do

  resources :sessions, only: [:new, :create, :destroy]
  resources :users, only: [:show]

  namespace :admin do
    resources :users, only: [:index]
  end

  root 'static_pages#home'

  get '/facilities', to: 'static_pages#facilities'
  get '/directions', to: 'static_pages#directions'

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  #root "/home"

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  get "/signin",  to: "sessions#new"
  match "/signout", to: "sessions#destroy", via: 'get'
  post "/signin", to: "sessions#create"
  delete "/signout", to: "sessions#destroy"

end
