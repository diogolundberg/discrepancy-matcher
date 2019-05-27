# frozen_string_literal: true

require 'service'
require 'discrepancy_matcher/fetch_remote'

module DiscrepancyMatcher
  class Match < Service
    def initialize(local_data, fetch_remote_service: FetchRemote)
      @local_data = local_data.dup
      @fetch_remote_service = fetch_remote_service
    end

    def call
      @fetch_remote = fetch_remote_service.call
      result(success?: true, result: match_data)
    end

    private

    attr_reader :local_data, :fetch_remote, :fetch_remote_service

    def match_data
      fetch_remote.result.inject([]) do |result, remote|
        reference = remote[:reference]
        local = find_local(reference)
        discrepancies = {}
        %i[status description].each do |attribute|
          discrepancy = find_discrepancy(local, remote, attribute)
          discrepancies[attribute] = discrepancy if discrepancy
        end

        result << { remote_reference: reference, discrepancies: discrepancies }
      end
    end

    def find_local(reference)
      local = local_data.find { |d| d[:external_reference] == reference }
      return {} if local.nil?

      local[:description] = local.delete(:ad_description)
      local
    end

    def find_discrepancy(local, remote, attribute)
      return unless local[attribute] != remote[attribute]

      { local: local[attribute] || '', remote: remote[attribute] }
    end
  end
end
