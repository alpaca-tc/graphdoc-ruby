# frozen_string_literal: true

require 'bundler/setup'
require 'graphdoc-ruby'

RSpec.configure do |config|
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
