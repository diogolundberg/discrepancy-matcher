# frozen_string_literal: true

require 'net/http'
require 'json'
require 'service'

module DiscrepancyMatcher
  class FetchRemote < Service
    def initialize
      @uri = URI.parse(Config.remote_url)
    end

    def call
      fetch
      result(success?: true, result: body['ads'] || [])
    rescue JSON::ParserError, Net::HTTPError => e
      result(success?: false, error: e)
    end

    private

    attr_reader :uri, :response

    def fetch
      @response = Net::HTTP.get_response(uri)
      response.error! unless response.is_a?(Net::HTTPOK)
    end

    def body
      JSON.parse(response.body)
    end
  end
end
