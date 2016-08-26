Rails.application.routes.draw do
  root   'home#index'

  get    'auth/yahoo' => 'users#authorize_request_token' unless Rails.application.config.lock_app
  get    'auth/yahoo/callback' => 'users#token_callback' unless Rails.application.config.lock_app
  get    'settings' => 'settings#index' unless Rails.application.config.lock_app

  get    'debug' => 'debug#index' if Rails.env == 'development'
end
