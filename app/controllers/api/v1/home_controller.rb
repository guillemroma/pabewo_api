# frozen_string_literal: true

module Api
    module V1
      class HomeController < ApplicationController
        def index
            render json: { message: 'Connected to API' }
        end
      end
    end
  end
