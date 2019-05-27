# frozen_string_literal: true

require 'net/http'
require 'json'

module DiscrepancyMatcher
  class FetchRemote
    Result = Struct.new(:success?, :result, :error, keyword_init: true)

    def self.call(*args)
      new(*args).call
    end

    def initialize
      @uri = URI.parse(Config.remote_url)
    end

    def call
      fetch
      Result.new(success?: true, result: body['ads'] || [])
    rescue JSON::ParserError, Net::HTTPError => e
      Result.new(success?: false, error: e)
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
