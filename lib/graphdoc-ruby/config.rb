# frozen_string_literal: true

require 'bundler'

module GraphdocRuby
  class Config
    attr_accessor :endpoint
    attr_accessor :executable_path
    attr_accessor :output_directory
    attr_accessor :overwrite
    attr_accessor :precompile
    attr_accessor :mtime

    def initialize
      self.endpoint = nil
      self.executable_path = Bundler.which('graphdoc')
      self.output_directory = default_output_directory
      self.overwrite = false
      self.precompile = default_precompile
      self.mtime = Time.now
    end

    private

    def default_output_directory
      if defined?(::Rails) && ::Rails.application.respond_to?(:paths)
        File.join(::Rails.application.paths['tmp'].first, 'graphdoc')
      else
        File.join(Dir.mktmpdir, 'graphdoc')
      end
    end

    def default_precompile
      if defined?(::Rails) && ::Rails.respond_to?(:env)
        ::Rails.env.production?
      else
        false
      end
    end
  end
end
