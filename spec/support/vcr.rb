# frozen_string_literal: true

require "vcr"

VCR.configure do |c|
  c.hook_into :webmock
  c.cassette_library_dir = "fixtures/cassettes"
  c.default_cassette_options = {record: :once}
  c.configure_rspec_metadata!
end

RSpec.configure do |config|
  config.before smoke_test: true do
    VCR.configure do |c|
      @previous_allow_http_connections = c.allow_http_connections_when_no_cassette?
      c.allow_http_connections_when_no_cassette = true
    end
  end

  config.after smoke_test: true do
    VCR.configure do |c|
      c.allow_http_connections_when_no_cassette = @previous_allow_http_connections
    end
  end
end
