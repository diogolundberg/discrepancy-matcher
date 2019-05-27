# frozen_string_literal: true

require 'discrepancy_matcher/config'
require 'discrepancy_matcher/match'
require 'discrepancy_matcher/fetch_remote'

module DiscrepancyMatcher
  def self.configure
    yield Config
  end
end
