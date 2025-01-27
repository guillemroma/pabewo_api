Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      post '/telegram_webhook', to: 'telegram#webhook'
    end
  end
end