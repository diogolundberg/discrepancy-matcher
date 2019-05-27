# frozen_string_literal: true

$LOAD_PATH.unshift(File.expand_path('lib', __dir__))

require_relative 'db/setup'
require_relative 'db/seed'
require 'discrepancy_matcher'

DiscrepancyMatcher.configure { |config| config.remote_url = ENV['REMOTE_URL'] }
campains = DB[:campains].to_hash(%i[external_reference ad_description status])

discrepancy_match = DiscrepancyMatcher::Match.call(campains.values)

if discrepancy_match.success?
  puts discrepancy_match.result
else
  puts discrepancy_match.error
end
