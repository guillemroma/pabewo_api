# frozen_string_literal: true

Rails.application.routes.draw do
  root 'api/v1/home#index'

  namespace :api do
    namespace :v1 do
      get '/', to: 'home#index'
      post '/telegram_webhook', to: 'telegram#webhook'
    end
  end
end
