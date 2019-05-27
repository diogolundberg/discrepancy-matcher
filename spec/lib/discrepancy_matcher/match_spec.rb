# frozen_string_literal: true

require 'discrepancy_matcher'

RSpec.describe DiscrepancyMatcher::Match do
  let(:local) { [] }
  let(:fetch_remote_service) { double('Fetch Remote Service') }
  subject(:service) do
    described_class.new(local, fetch_remote_service: fetch_remote_service)
  end

  describe '#call' do
    subject(:service) { class_double('Match') }

    before do
      allow(service).to receive(:call)
      allow(described_class).to receive(:new).and_return(service)
      described_class.call('param', fetch_remote_service: 'fetch_remote')
    end

    it 'initialize service instance with right parameters' do
      expect(described_class).to have_received(:new)
        .with('param', fetch_remote_service: 'fetch_remote')
    end

    it 'calls service instance' do
      expect(service).to have_received(:call)
    end
  end

  describe '#call' do
    let(:fetch_remote) { double('Fetch Remote Result') }

    before do
      allow(fetch_remote_service).to receive(:call).and_return(fetch_remote)
    end

    context 'when remotes are empty' do
      before { allow(fetch_remote).to receive(:result).and_return([]) }

      it 'is a success' do
        expect(service.call).to be_success
      end

      it 'returns empty result' do
        expect(service.call.result).to be_empty
      end
    end

    context 'when remotes not empty' do
      before do
        remote_data = [
          {
            'reference': '1',
            'status': 'enabled',
            'description': 'Description 1',
          },
          {
            'reference': '2',
            'status': 'disabled',
            'description': 'Description 2',
          },
        ]

        allow(fetch_remote).to receive(:result).and_return(remote_data)
      end

      context 'and have no local match' do
        it 'is a success' do
          expect(service.call).to be_success
        end

        it 'returns discrepancy for all remote fields with local empty' do
          expected = [
            {
              'remote_reference': '1',
              'discrepancies': {
                'status': {
                  'remote': 'enabled',
                  'local': '',
                },
                'description': {
                  'remote': 'Description 1',
                  'local': '',
                },
              },
            },
            {
              'remote_reference': '2',
              'discrepancies': {
                'status': {
                  'remote': 'disabled',
                  'local': '',
                },
                'description': {
                  'remote': 'Description 2',
                  'local': '',
                },
              },
            },
          ]

          expect(service.call.result).to match_array(expected)
        end
      end

      context 'and have local discrepancies' do
        let(:local) do
          [
            {
              'external_reference': '1',
              'status': 'enabled',
              'ad_description': 'Local Description 1',
            },
            {
              'external_reference': '2',
              'status': 'paused',
              'ad_description': 'Description 2',
            },
          ]
        end

        it 'is a success' do
          expect(service.call).to be_success
        end

        it 'returns discrepancies for remote fields' do
          expected = [
            {
              'remote_reference': '1',
              'discrepancies': {
                'description': {
                  'remote': 'Description 1',
                  'local': 'Local Description 1',
                },
              },
            },
            {
              'remote_reference': '2',
              'discrepancies': {
                'status': {
                  'remote': 'disabled',
                  'local': 'paused',
                },
              },
            },
          ]

          expect(service.call.result).to match_array(expected)
        end
      end
    end
  end
end
