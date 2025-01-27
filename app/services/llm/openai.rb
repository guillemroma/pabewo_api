# frozen_string_literal: true

module Llm
  class Openai
    def initialize
      @client = OpenAI::Client.new(access_token: ENV.fetch('OPENAI_API_KEY'))
    end

    def generate_message
      response = @client.chat(parameters: { model: 'gpt-3.5-turbo',
                                            messages: [{ role: 'user', content: 'Write a poem about the moon' }], temperature: 0.7 })
      response.dig('choices', 0, 'message', 'content')
    end
  end
end
