# frozen_string_literal: true

module Telegram
  class MessageService
    def initialize(params)
      @params = params
      @errors = []
    end

    def send
      extract_params
      validate_params
      return false if @errors.any?

      prepare_message
      send_message
      @errors.none?
    end

    private

    def extract_params
      @chat_id = @params.dig('message', 'chat', 'id')
      @received_message = @params.dig('message', 'text')
      @message_thread_id = @params.dig('message', 'message_thread_id')
    end

    def validate_params
      @errors << 'Chat ID is missing' if @chat_id.blank?
      @errors << 'Message text is missing' if @received_message.blank?
    end

    def prepare_message
      service = Llm::Openai.new
      @response_message = service.generate_message
    end

    def send_message
      token = ENV.fetch('TELEGRAM_BOT_TOKEN')
      client = Telegram::Bot::Client.new(token)

      client.api.send_message(chat_id: @chat_id, text: @response_message, message_thread_id: @message_thread_id)
    rescue StandardError => e
      @errors << "Failed to send message: #{e.message}"
    end
  end
end
