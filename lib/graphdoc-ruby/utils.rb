# frozen_string_literal: true

module GraphdocRuby
  module Utils
    def self.valid_url?(url)
      uri = URI.parse(url)
      uri.host
    rescue StandardError
      false
    end

    def self.file_exist?(path)
      File.exist?(path)
    end
  end
end
