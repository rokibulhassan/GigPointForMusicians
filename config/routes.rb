GigpointForMusician::Application.routes.draw do

  devise_for :users, :controllers => {:omniauth_callbacks => 'users/omniauth_callbacks'}  do
    get '/users/auth/:provider' => 'users/omniauth_callbacks#passthru'
  end

  get 'static/home', as: :home

  resources :users
  resources :profiles

  root :to => 'static#home'
end
