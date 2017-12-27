# This file is used by Rack-based servers to start the application for debug.

require 'pry'
require 'graphdoc_ruby'

class Reloader
  def initialize(app)
    @app = app
  end

  def call(env)
    reload!
    @app.call(env)
  end

  private

  def reload!
    # load(File.expand_path('../lib/graphdoc-ruby/application.rb', __FILE__))
    # load(File.expand_path('../lib/graphdoc-ruby/graphdoc.rb', __FILE__))
    # load(File.expand_path('../lib/graphdoc-ruby/static.rb', __FILE__))
  end
end

endpoint = 'https://graphql-pokemon.now.sh/'
directory = '/tmp/directory'

GraphdocRuby.configure do |config|
  config.endpoint = endpoint
  config.output_directory = directory
  config.overwrite = true
end

use(Reloader)
run(GraphdocRuby::Application)
