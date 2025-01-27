# frozen_string_literal: true

module Api
  module V1
    class TelegramController < ApplicationController
      def webhook
        token = ENV.fetch('TELEGRAM_BOT_TOKEN')
        client = Telegram::Bot::Client.new(ENV.fetch('TELEGRAM_BOT_TOKEN'))

        Rails.logger.info("params: #{params}")

        chat_id = params.dig("message", "chat", "id")
        message_thread_id = params.dig("message", "message_thread_id")

        Rails.logger.info("chat_id: #{chat_id}")
        Rails.logger.info("message_thread_id: #{message_thread_id}")

        if message_thread_id.present?
          reply_message(client, chat_id, message_thread_id, "This is a reply in the topic.")
        else
          reply_message(client, chat_id, nil, "This is a reply in the private chat.")
        end

        render json: { status: "success" }, status: :ok                
      end

      def reply_message(client, chat_id, message_thread_id, message)
        client.api.send_message(chat_id: chat_id, text: message, message_thread_id: message_thread_id)
      end
    end
  end
end