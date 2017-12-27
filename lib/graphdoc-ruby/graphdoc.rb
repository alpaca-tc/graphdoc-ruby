# frozen_string_literal: true

require 'open3'
module GraphdocRuby
  class Graphdoc
    def initialize(output:, endpoint:, overwrite:, executable:, mtime:)
      @endpoint = endpoint
      @executable = executable
      @overwrite = overwrite
      @mtime = mtime

      @output_html = File.join(output, 'index.html')
      @options = ['--output', output]
      @options += ['--force'] if overwrite
    end

    def generate_document!
      return if generated?

      message, status = Open3.capture2e(*command)
      raise "Command failed. (#{command}) '#{message}'" unless status.success?
    end

    private

    def generated?
      GraphdocRuby::Utils.file_exist?(@output_html) && (!@overwrite || (@overwrite && regenerated?))
    end

    def regenerated?
      File::Stat.new(@output_html).mtime >= @mtime
    rescue Errno::ENOENT
      false
    end

    def command
      if GraphdocRuby::Utils.valid_url?(@endpoint)
        [@executable, '--endpoint', @endpoint, *@options]
      elsif GraphdocRuby::Utils.file_exist?(@endpoint)
        [@executable, '--schema-file', @endpoint, *@options]
      else
        raise "Invalid endpoint given. endpoint(#{@endpoint}) must be valid URL or existing schema file"
      end
    end
  end
end
