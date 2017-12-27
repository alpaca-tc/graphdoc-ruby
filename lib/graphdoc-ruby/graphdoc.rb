# frozen_string_literal: true

require 'open3'
module GraphdocRuby
  class Graphdoc
    Semaphore = Mutex.new

    def initialize(output:, endpoint:, overwrite:, executable:, mtime:)
      raise ArgumentError, 'endpoint is not found. Missing GraphdocRuby.config.endpoint = "https://your-graphql-service.com/graphql"' unless endpoint

      @endpoint = endpoint
      @executable = executable
      @overwrite = overwrite
      @mtime = mtime

      @output_html = File.join(output, 'index.html')
      @options = ['--output', output]
      @options += ['--force'] if overwrite
    end

    def generated?
      File.exist?(@output_html) && (!@overwrite || (@overwrite && regenerated?))
    end

    def generate_document!
      Semaphore.synchronize do
        return if generated?

        message, status = Open3.capture2e(*command)
        raise "Command failed. (#{command}) '#{message}'" unless status.success?
      end
    end

    private

    def regenerated?
      File::Stat.new(@output_html).mtime >= @mtime
    rescue Errno::ENOENT
      false
    end

    def command
      if File.exist?(@endpoint)
        [executable, '--schema-file', @endpoint, *@options]
      else
        [executable, '--endpoint', @endpoint, *@options]
      end
    end

    def executable
      @executable || raise('command not found: graphdoc. Please install graphdoc (npm install -g @2fd/graphdoc)')
    end
  end
end
