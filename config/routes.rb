Rails.application.routes.draw do

  resources :sessions, only: [:new, :create, :destroy]
  resources :users, only: [:show]
  resources :season_detail_lines, only: [:show]

  namespace :admin do
    resources :users, only: [:index]
    resources :accommodation_types do
      resources :tariffs
    end    
    resources :season_detail_lines do
      member do
        get :no_powerpoints
        get :with_powerpoints
      end
    end
  end

  root 'static_pages#home'

  get '/facilities', to: 'static_pages#facilities'
  get '/accommodation', to: 'season_detail_lines#show'
  get '/directions', to: 'static_pages#directions'
  get '/test', to: 'static_pages#test'

  # match "/admin/season_detail_lines/no_powerpoints", to: "admin/season_detail_lines#no_powerpoints", via: 'get'

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
