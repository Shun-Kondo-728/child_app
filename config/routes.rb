Rails.application.routes.draw do
  get 'sessions/new'
  root 'static_pages#home'
  get :help, to: 'static_pages#help'
  get :signup, to: 'users#new'
  resources :users do
    member do
      get :following, :followers
    end
  end
  resources :posts
  get    :login,     to: 'sessions#new'
  post   :login,     to: 'sessions#create'
  delete :logout,    to: 'sessions#destroy'
  resources :relationships, only: [:create, :destroy]
  get :likes, to: 'likes#index'
  post   "likes/:post_id/create"  => "likes#create"
  delete "likes/:post_id/destroy" => "likes#destroy"
  resources :comments, only: [:create, :destroy]
  resources :talks,               only: [:show, :create] do
    member do
      post  :memberships, :messages
    end
  end
  resources :messages,            only: [:create, :destroy]
  resources :notifications, only: :index
  resources :problems
  get :problem_search, to: 'problems#problem_search'
  resources :problem_comments, only: [:create, :destroy]
end
