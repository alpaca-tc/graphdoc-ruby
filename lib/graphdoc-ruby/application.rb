# frozen_string_literal: true

module GraphdocRuby
  class Application
    def self.call(env)
      @application ||= new
      @application.call(env)
    end

    def initialize(
      output_directory: GraphdocRuby.config.output_directory,
      executable_path: GraphdocRuby.config.executable_path,
      endpoint: GraphdocRuby.config.endpoint,
      overwrite: GraphdocRuby.config.overwrite,
      mtime: GraphdocRuby.config.mtime
    )
      GraphdocRuby::Graphdoc.new(
        output: output_directory,
        executable: executable_path,
        endpoint: endpoint,
        overwrite: overwrite,
        mtime: mtime
      ).generate_document!

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
