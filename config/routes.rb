GigpointForMusician::Application.routes.draw do

  devise_for :users

  get 'static/home', as: :home

  resources :users
  resources :profiles

  root :to => 'static#home'
end
