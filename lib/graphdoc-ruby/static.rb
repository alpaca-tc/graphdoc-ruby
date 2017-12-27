# frozen_string_literal: true

require 'rack/utils'
require 'active_support/core_ext/uri'

module GraphdocRuby
  class Static
    def initialize(root, headers: {})
      @root = root.chomp('/')
      @file_server = ::Rack::File.new(@root, headers)
    end

    def match?(path)
      path = ::Rack::Utils.unescape_path(path)
      return false unless ::Rack::Utils.valid_path? path
      path = ::Rack::Utils.clean_path_info(path)

      candidate_paths = [path, "#{path}.html", "#{path}/index.html"]

      match = candidate_paths.detect do |candidate_path|
        absolute_path = File.join(@root, candidate_path.dup.force_encoding(Encoding::UTF_8))

        begin
          File.file?(absolute_path) && File.readable?(absolute_path)
        rescue SystemCallError
          false
        end
      end

      ::Rack::Utils.escape_path(match) if match
    end

    def serve(request)
      @file_server.call(request.env)
    end
  end
end
