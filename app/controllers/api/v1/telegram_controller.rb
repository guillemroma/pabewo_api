# frozen_string_literal: true

module Api
  module V1
    class TelegramController < ApplicationController
      def webhook
        token = ENV.fetch('TELEGRAM_BOT_TOKEN')

        Telegram::Bot::Client.run(token) do |bot|
          bot.listen do |message|
            chat_id = message.chat.id
            message_thread_id = message.message_thread_id
            user_name = message.from.first_name
        
            response_text = "Hello, #{user_name}! This is a reply."
        
            if thread_id
              bot.api.send_message(
                chat_id: chat_id,
                text: response_text,
                message_thread_id: thread_id
              )
            else
              bot.api.send_message(
                chat_id: chat_id,
                text: response_text
              )
            end
          end
        end
      end
    end
  end
end