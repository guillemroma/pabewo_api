# frozen_string_literal: true

require File.expand_path('../config/environment', __dir__)

RSpec.configure do |config|
  config.include Rails.application.routes.url_helpers
  config.include ActionDispatch::IntegrationTest::Behavior, type: :request

  config.before(:each) do
    allow(ENV).to receive(:fetch).with('TELEGRAM_BOT_TOKEN').and_return('fake-telegram-token')
    allow(ENV).to receive(:fetch).with('OPENAI_API_KEY').and_return('fake-openai-key')
    allow(ENV).to receive(:fetch).with('REDIS_URL').and_call_original
  end
end
