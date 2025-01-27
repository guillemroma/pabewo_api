# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Llm::Openai do
  describe '#generate_message' do
    let(:service) { described_class.new }
    let(:mock_client) { instance_double(OpenAI::Client) }
    let(:mock_response) do
      {
        'choices' => [
          {
            'message' => {
              'content' => 'Generated poem about the moon'
            }
          }
        ]
      }
    end

    before do
      allow(OpenAI::Client).to receive(:new).and_return(mock_client)
      allow(mock_client).to receive(:chat).and_return(mock_response)
    end

    it 'generates message using OpenAI API' do
      expect(service.generate_message).to eq('Generated poem about the moon')
    end

    it 'calls OpenAI API with correct parameters' do
      expected_params = {
        model: 'gpt-3.5-turbo',
        messages: [{ role: 'user', content: 'Write a poem about the moon' }],
        temperature: 0.7
      }

      expect(mock_client).to receive(:chat).with(parameters: expected_params)
      service.generate_message
    end

    context 'when API call fails' do
      before do
        allow(mock_client).to receive(:chat).and_raise(StandardError.new('API Error'))
      end

      it 'raises the error' do
        expect { service.generate_message }.to raise_error(StandardError, 'API Error')
      end
    end
  end
end
