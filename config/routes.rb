Rails.application.routes.draw do
  
  root   'static_pages#home'
  get    '/about',   to: 'static_pages#about'
  get    '/signup',  to: 'users#new'
  get    '/login',   to: 'sessions#new'
  delete '/logout',  to: 'sessions#destroy'
  post   '/login',   to: 'sessions#create'
  resources :users
end
