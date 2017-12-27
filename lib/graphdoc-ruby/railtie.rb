# frozen_string_literal: true

module GraphdocRuby
  class Railtie < Rails::Railtie
    rake_tasks do
      require 'graphdoc-ruby/rake_task'

      GraphdocRuby::RakeTask.new
    end
  end
end
