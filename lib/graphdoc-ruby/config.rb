# frozen_string_literal: true

require 'bundler'

module GraphdocRuby
  class Config
    class InvalidConfiguration < StandardError; end

    # Required: <String>
    # GraphQL endpoint url or dumped schema.json path.
    attr_reader :endpoint

    # Optional: <String>
    # Executable path of `graphdoc`.
    # (default: `Bundler.which('graphdoc')`)
    attr_accessor :executable_path

    # Optional: <String>
    # Output path for `graphdoc`. If you disabled run_time_generation, this value is required.
    # (default: `File.join(Dir.mktmpdir, 'graphdoc')`)
    attr_reader :output_directory

    # Optional: <Boolean>
    # Overwrite directory if output_directory exist.
    # (default: true)
    attr_accessor :overwrite

    # Optional: <Boolean>
    # Generate html with graphdoc on the first access.
    # (default: true)
    attr_accessor :run_time_generation

    # Optional: <String>
    # Schema name of your graphql-ruby. It is necessary when generating schema.json.
    attr_accessor :schema_name

    # Optional: <Hash>
    # Context of your graphql-ruby. It is necessary when generating schema.json.
    attr_accessor :graphql_context

    # no doc
    attr_reader :mtime

    def initialize
      self.endpoint = nil
      self.executable_path = Bundler.which('graphdoc')
      self.output_directory = default_output_directory
      self.overwrite = true
      self.run_time_generation = true
      self.schema_name = nil
      self.graphql_context = {}

      @use_temporary_output_directory = true
      @mtime = Time.now
    end

    def endpoint=(value)
      @endpoint = value.to_s
    end

    def output_directory=(value)
      @output_directory = value.to_s
      @use_temporary_output_directory = false
    end

    def assert_configuration!
      unless endpoint
        raise InvalidConfiguration, "(endpoint: '#{endpoint}') must be GraphQL endpoint url or dumped schema.json path."
      end

      if @use_temporary_output_directory && !run_time_generation
        raise InvalidConfiguration, 'If you disabled run_time_generation, static `output_directory` must be set.'
      end

      unless File.executable?(executable_path)
        raise InvalidConfiguration, '`graphdoc` not found. Please install graphdoc (npm install -g @2fd/graphdoc)'
      end
    end

    private

    def default_output_directory
      File.join(Dir.mktmpdir, 'graphdoc')
    end
  end
end
