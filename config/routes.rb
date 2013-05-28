GigpointForMusician::Application.routes.draw do

  devise_for :admin_users, ActiveAdmin::Devise.config

  root :to => 'static#home'

  ActiveAdmin.routes(self)

  resources :pages


  devise_for :users, :controllers => {:omniauth_callbacks => 'users/omniauth_callbacks'} do
    ActiveAdmin.routes(self)
    get '/users/auth/:provider' => 'users/omniauth_callbacks#passthru'
  end

  get 'static/home', as: :home

  resources :users do
    member do
      get 'profile'
      get 'destroy_authentication'
    end
    collection do
      get 'update_authentication'
      get 'callback'
    end
  end
  resources :artists do
    resources :profiles
  end

  resources :gigs do
    member do
      get 'post_to_facebook'
    end
  end

  resources :venues do
    collection do
      get 'auto_complete'
      get 'populate_location_map'
    end
  end

end
