GigpointForMusician::Application.routes.draw do

  resources :pages


  devise_for :users, :controllers => {:omniauth_callbacks => 'users/omniauth_callbacks'}  do
    get '/users/auth/:provider' => 'users/omniauth_callbacks#passthru'
  end

  get 'static/home', as: :home

  resources :users
  resources :artists do
    resources :profiles
  end

  root :to => 'static#home'
end
