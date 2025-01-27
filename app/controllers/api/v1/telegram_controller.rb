# frozen_string_literal: true

module Api
  module V1
    class TelegramController < ApplicationController
      def webhook
        token = ENV.fetch('TELEGRAM_BOT_TOKEN')
        client = Telegram::Bot::Client.new(ENV.fetch('TELEGRAM_BOT_TOKEN'))
        client.api.send_message(chat_id: '6399219195', text: "Hola @#{Time.now} / #{params[:message]}")
      end
    end
  end
end