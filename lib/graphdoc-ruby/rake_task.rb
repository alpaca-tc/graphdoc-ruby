require 'graphdoc-ruby'

module GraphdocRuby
  class RakeTask
    include Rake::DSL

    # Set the parameters of this task by passing keyword arguments
    # or assigning attributes inside the block
    def initialize
      dependencies = if defined?(::Rails)
        [:environment]
      else
        []
      end

      define_tasks(dependencies)
    end

    private

    def define_tasks(dependencies)
      namespace :graphdoc do
        desc 'Dump GraphQL schema to endpoint'
        task dump_schema: dependencies do
          require 'graphdoc-ruby/graphql_json'
          raise(ArgumentError, 'GraphdocRuby.config.schema_name is required.') unless GraphdocRuby.config.schema_name

          puts "-- Write schema.json to #{GraphdocRuby.config.endpoint}"
          GraphdocRuby::GraphqlJson.write_schema_json
        end

        desc 'Generate html with graphdoc'
        task generate: dependencies do
          puts "-- Generate html with graphdoc from #{GraphdocRuby.config.endpoint}"
          GraphdocRuby::Application.graphdoc.generate_document!
          puts "-- Generated html to #{GraphdocRuby.config.output_directory}"
        end
      end
    end
  end
end
