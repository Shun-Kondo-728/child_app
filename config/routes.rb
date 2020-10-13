Rails.application.routes.draw do
  # frozen_string_literal: true
  root 'static_pages#home'
  get :help, to: 'static_pages#help'
end
