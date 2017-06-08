Rails.application.routes.draw do
  
  root   'static_pages#home'
  get    '/about',   to: 'static_pages#about'
  get    '/signup',  to: 'users#new'
  post   '/signup',  to: 'users#create'
  get    '/reset',   to: 'password_resets#new'
  post   '/reset',   to: 'password_resets#create'
  delete '/logout',  to: 'sessions#destroy'
  post   '/login',   to: 'sessions#create'
  resources :users
  resources :account_activations, only: [:edit]
  resources :microposts,          only: [:edit, :update, :create, :destroy]
  resources :password_resets,     only: [:new, :create, :edit, :update]
  resources :relationships,       only: [:create, :destroy]
  resources :users do
    member do
      get :following, :followers
    end
  end
end
