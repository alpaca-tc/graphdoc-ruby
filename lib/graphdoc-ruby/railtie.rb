module GraphdocRuby
  class Railtie < Rails::Railtie
    config.after_initialize do
      next unless GraphdocRuby.config.precompile
      GraphdocRuby::Application.graphdoc.generate_document!
    end
  end
end
