Rails.application.routes.draw do
  devise_for :users, path: '', path_names: { sign_in: 'login', sign_out: 'logout', sign_up: 'signup' }
  get    'teams' => 'teams#index'

  root   'home#index'
  get    'settings' => 'users#settings'
  patch  'settings' => 'users#update_settings'

  get    'auth/yahoo' => 'users#authorize_request_token'
  get    'auth/yahoo/callback' => 'users#token_callback'

  get    'debug' => 'debug#access' if Rails.env == 'development'

  resources :users
end
