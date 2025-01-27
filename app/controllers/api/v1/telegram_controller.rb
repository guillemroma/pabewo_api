# frozen_string_literal: true

module Api
  module V1
    class TelegramController < ApplicationController
      def webhook
        service = Telegram::MessageService.new(params)

        if service.send
          render json: { status: 'success' }, status: :ok
        else
          render json: { status: 'error', errors: service.errors }, status: :unprocessable_entity
        end
      end
    end
  end
end
