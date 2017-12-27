# frozen_string_literal: true

require 'rack'
require 'graphdoc-ruby/utils'
require 'graphdoc-ruby/graphdoc'
require 'graphdoc-ruby/static'
require 'graphdoc-ruby/application'
require 'graphdoc-ruby/config'
require 'graphdoc-ruby/graphql_json'
require 'graphdoc-ruby/version'

module GraphdocRuby
  def self.config
    @config ||= GraphdocRuby::Config.new
  end

  def self.configure
    yield(config)
  end
end

require 'graphdoc-ruby/railtie' if defined?(Rails)
