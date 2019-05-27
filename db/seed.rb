# frozen_string_literal: true

DB[:campains].insert(
  external_reference: 1, status: 'disabled', ad_description: 'campaign 1'
)

DB[:campains].insert(
  external_reference: 2, status: 'enabled', ad_description: 'campaign 2'
)

DB[:campains].insert(
  external_reference: 3, status: 'paused', ad_description: 'campaign 3'
)
