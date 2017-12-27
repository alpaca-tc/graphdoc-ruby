require 'fileutils'

module GraphdocRuby
  class GraphqlJson
    def self.write_schema_json
      new(
        GraphdocRuby.config.schema_name,
        GraphdocRuby.config.endpoint,
        GraphdocRuby.config.graphql_context
      ).write_json
    end

    def initialize(schema_name, output_file, context = {})
      @schema_name = schema_name
      @output_file = output_file
      @context = context
    end

    def write_json
      json = schema.to_json(context: @context)

      directory = File.dirname(@output_file)
      FileUtils.mkdir_p(directory)

      File.write(@output_file, json)
    end

    private

    def schema
      @schema ||= Object.const_get(@schema_name.to_s)
    rescue
      raise GraphdocRuby::Config::InvalidConfiguration, "(schema_name: #{@schema_name}) must be GraphQL Schema"
    end
  end
end
