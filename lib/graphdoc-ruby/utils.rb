module GraphdocRuby
  module Utils
    extend self

    def valid_url?(url)
      uri = URI.parse(url)
      uri.host
    rescue StandardError
      false
    end

    def file_exist?(path)
      File.exist?(path)
    end
  end
end
