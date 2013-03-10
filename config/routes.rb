GigpointForMusician::Application.routes.draw do

  get 'static/home', as: :home
  resources :profiles
  root :to => 'static#home'
end
