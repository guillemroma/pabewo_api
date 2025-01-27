# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Telegram::MessageService do
  let(:valid_params) do
    {
      'message' => {
        'chat' => { 'id' => '123456' },
        'text' => 'Hello bot',
        'message_thread_id' => '789'
      }
    }
  end

  describe '#send' do
    let(:service) { described_class.new(valid_params) }
    let(:openai_service) { instance_double(Llm::Openai) }
    let(:telegram_client) { instance_double(Telegram::Bot::Client) }
    let(:telegram_api) { double('Telegram::Bot::Api') }

    before do
      allow(telegram_api).to receive(:send_message).with(
        chat_id: '123456',
        text: 'AI response',
        message_thread_id: '789'
      ).and_return(true)
      allow(Llm::Openai).to receive(:new).and_return(openai_service)
      allow(openai_service).to receive(:generate_message).and_return('AI response')
      allow(Telegram::Bot::Client).to receive(:new).and_return(telegram_client)
      allow(telegram_client).to receive(:api).and_return(telegram_api)
    end

    context 'when all parameters are valid' do
      it 'sends message successfully' do
        expect(service.send).to be true
        expect(service.instance_variable_get(:@errors)).to be_empty
      end
    end

    context 'when chat_id is missing' do
      let(:invalid_params) { { 'message' => { 'text' => 'Hello' } } }
      let(:service) { described_class.new(invalid_params) }

      it 'returns false and adds error' do
        expect(service.send).to be false
        expect(service.instance_variable_get(:@errors)).to include('Chat ID is missing')
      end
    end

    context 'when message text is missing' do
      let(:invalid_params) { { 'message' => { 'chat' => { 'id' => '123456' } } } }
      let(:service) { described_class.new(invalid_params) }

      it 'returns false and adds error' do
        expect(service.send).to be false
        expect(service.instance_variable_get(:@errors)).to include('Message text is missing')
      end
    end

    context 'when telegram api raises error' do
      before do
        allow(telegram_api).to receive(:send_message).and_raise(StandardError.new('API Error'))
      end

      it 'catches error and adds to errors array' do
        expect(service.send).to be false
        expect(service.instance_variable_get(:@errors)).to include('Failed to send message: API Error')
      end
    end
  end
end
