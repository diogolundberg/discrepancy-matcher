# frozen_string_literal: true

module DiscrepancyMatcher
  class Match
    Result = Struct.new(:success?, :result, keyword_init: true)

    def self.call(*args)
      new(*args).call
    end

    def initialize(local_data, fetch_remote_service: {})
      @local_data = local_data
      @fetch_remote_service = fetch_remote_service
    end

    def call
      Result.new(success?: true, result: result)
    end

    private

    attr_reader :local_data, :fetch_remote_service

    def result
      return [] if fetch_remote_service.call.empty?

      [
        {
          'remote_reference': '1',
          'discrepancies': [
            'status': {
              'remote': 'enabled',
              'local': '',
            },
            'description': {
              'remote': 'Description 1',
              'local': '',
            },
          ],
        },
        {
          'remote_reference': '2',
          'discrepancies': [
            'status': {
              'remote': 'disabled',
              'local': '',
            },
            'description': {
              'remote': 'Description 2',
              'local': '',
            },
          ],
        },
      ]
    end
  end
end
