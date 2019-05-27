# frozen_string_literal: true

require 'discrepancy_matcher'

RSpec.describe DiscrepancyMatcher do
  describe '#configure' do
    described_class.configure { |config| config.remote_url = 'remote_url' }

    it 'contains configuration set in the block' do
      expect(DiscrepancyMatcher::Config.remote_url).to eq('remote_url')
    end

    it 'allows configuration to be changed' do
      allow(DiscrepancyMatcher::Config).to receive(:remote_url=)
      described_class.configure { |config| config.remote_url = 'new url' }

      expect(DiscrepancyMatcher::Config).to have_received(:remote_url=)
    end
  end
end
