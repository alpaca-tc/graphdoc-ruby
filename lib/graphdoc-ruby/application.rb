# frozen_string_literal: true

require 'bundler'
require 'timeout'

module GraphdocRuby
  class Application
    def initialize(endpoint:, graphdoc_path: Bundler.which('graphdoc'), output_directory: default_output_directory, timeout: 30, force: false)
      @graphdoc = GraphdocRuby::Graphdoc.new(output: output_directory, executable: graphdoc_path, endpoint: endpoint, force: force)
      @static = GraphdocRuby::Static.new(output_directory)
      @timeout = timeout
    end

    def call(env)
      unless @graphdoc.generated?
        Timeout.timeout(@timeout) { @graphdoc.generate_document! }
      end

      serve_static_file(env) || not_found
    rescue Timeout::Error
      [504, { 'Content-Type' => 'text/html' }, ['Timed out']]
    end

    private

    def default_output_directory
      if defined?(::Rails) && ::Rails.application.respond_to?(:paths)
        File.join(::Rails.application.paths['tmp'].first, 'graphdoc')
      else
        File.join(Dir.mktmpdir, 'graphdoc')
      end
    end

    def not_found
      [404, { 'Content-Type' => 'text/html' }, ['Not found']]
    end

    def serve_static_file(env)
      request = Rack::Request.new(env)

      if request.get? || request.head?
        path = request.path_info.chomp('/')
        match = @static.match?(path)

        if match
          request.path_info = match
          @static.serve(request)
        end
      end
    end
  end
end
