# frozen_string_literal: true

require 'open3'

module GraphdocRuby
  class Graphdoc
    Semaphore = Mutex.new

    def initialize(output:, endpoint:, force:, executable:)
      @endpoint = endpoint
      @executable = executable
      @force = force
      @generated = false

      @output_html = File.join(output, 'index.html')
      @options = ['--output', output]
      @options += ['--force'] if force
    end

    def generated?
      File.exist?(@output_html) && (!@force || (@force && @generated))
    end

    def generate_document!
      Semaphore.synchronize do
        return if @generated

        message, status = Open3.capture2e(*command)
        @generated = true

        raise "Command failed. (#{command}) '#{message}'" unless status.success?
      end
    end

    private

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
