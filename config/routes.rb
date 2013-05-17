GigpointForMusician::Application.routes.draw do

  resources :pages


  devise_for :users, :controllers => {:omniauth_callbacks => 'users/omniauth_callbacks'} do
    get '/users/auth/:provider' => 'users/omniauth_callbacks#passthru'
  end

  get 'static/home', as: :home

  resources :users do
    member do
      get 'profile'
      get 'destroy_authentication'
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

  root :to => 'static#home'
end
