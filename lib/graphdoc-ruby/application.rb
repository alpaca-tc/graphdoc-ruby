# frozen_string_literal: true

module GraphdocRuby
  class Application
    def self.call(env)
      @application ||= new
      @application.call(env)
    end

    def self.graphdoc
      GraphdocRuby::Graphdoc.new(
        output: GraphdocRuby.config.output_directory,
        executable: GraphdocRuby.config.executable_path,
        endpoint: GraphdocRuby.config.endpoint,
        overwrite: GraphdocRuby.config.overwrite,
        mtime: GraphdocRuby.config.mtime
      )
    end

    def initialize
      self.class.graphdoc.generate_document! unless GraphdocRuby.config.precompile
      @static = GraphdocRuby::Static.new(GraphdocRuby.config.output_directory)
    end

    def call(env)
      serve_static_file(env) || not_found
    end

    private

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
