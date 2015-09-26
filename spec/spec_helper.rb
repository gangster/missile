$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'pry'
require 'missile'
require 'wisper/rspec/matchers'

RSpec::configure do |config|
  config.include(Wisper::RSpec::BroadcastMatcher)
end
