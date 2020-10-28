Rails.application.routes.draw do
  get 'sessions/new'
  root 'static_pages#home'
  get :help, to: 'static_pages#help'
  get :signup, to: 'users#new'
  resources :users
  resources :posts
  get    :login,     to: 'sessions#new'
  post   :login,     to: 'sessions#create'
  delete :logout,    to: 'sessions#destroy'
end
