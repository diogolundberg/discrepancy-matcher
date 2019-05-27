# frozen_string_literal: true

require 'discrepancy_matcher'

RSpec.describe DiscrepancyMatcher::FetchRemote do
  let(:url) { 'https://httpstat.us/201' }
  subject(:service) { described_class.new }

  describe '.call' do
    subject(:service) { class_double('Match') }

    before do
      allow(service).to receive(:call)
      allow(described_class).to receive(:new).and_return(service)
      described_class.call
    end

    it 'initialize service instance with right parameters' do
      expect(described_class).to have_received(:new)
    end

    it 'calls service instance' do
      expect(service).to have_received(:call)
    end
  end

  describe '#call' do
    before do
      allow(DiscrepancyMatcher::Config).to receive(:remote_url).and_return(url)
    end

    context 'when response is valid', vcr: { cassette_name: 'valid' } do
      let(:url) { 'https://mockbin.org/valid' }

      it 'is a success' do
        expect(service.call).to be_success
      end

      it 'returns remote data on result' do
        expected = [
          { 'reference' => '1',
            'description' => 'Description 1', 'status' => 'enabled', },
          { 'reference' => '2',
            'description' => 'Description 2', 'status' => 'disabled', },
        ]

        expect(service.call.result).to eq(expected)
      end

      it 'returns no error' do
        expect(service.call.error).to be_nil
      end
    end

    context 'when no items on envelope', vcr: { cassette_name: 'empty' } do
      let(:url) { 'https://mockbin.org/empty' }

      it 'is a success' do
        expect(service.call).to be_success
      end

      it 'returns empty results' do
        expect(service.call.result).to be_empty
      end

      it 'returns no error' do
        expect(service.call.error).to be_nil
      end
    end

    context 'when code is not OK', vcr: { cassette_name: 'not_ok' } do
      let(:url) { 'https://httpstat.us/201' }

      it 'is not a success' do
        expect(service.call).to_not be_success
      end

      it 'returns no result' do
        expect(service.call.result).to be_nil
      end

      it 'returns http error' do
        expect(service.call.error).to be_an_instance_of(Net::HTTPError)
      end
    end

    context 'when body is invalid', vcr: { cassette_name: 'invalid_body' } do
      let(:url) { 'https://mockbin.org/invalid_body' }

      it 'is not a success' do
        expect(service.call).to_not be_success
      end

      it 'returns no results' do
        expect(service.call.result).to be_nil
      end

      it 'returns json parser error' do
        expect(service.call.error).to be_an_instance_of(JSON::ParserError)
      end
    end
  end
end
