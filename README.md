# Graphdoc::Ruby

Mountable [graphdoc](https://github.com/2fd/graphdoc) based on rake.
graphdoc is static page generator for documenting GraphQL Schema.

<img width="1169" alt="screen" src="https://user-images.githubusercontent.com/1688137/34389782-11c80450-eb7f-11e7-8b83-fdfbcbfa711e.png">

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'graphdoc-ruby'
```

Install graphdoc to your machine:

```sh
$ npm install -g @2fd/graphdoc

OR

$ yarn add @2fd/graphdoc
```

## Usage

### In pure rake application

```ruby
# config.ru

require 'graphdoc_ruby'

GraphdocRuby.configure do |config|
  # endpoint of GraphQL
  config.endpoint = 'https://graphql-pokemon.now.sh/'
end

run(GraphdocRuby::Application)
```

```sh
$ gem install rack
$ bundle exec rackup
```

### In rails application

```ruby
# config/routes.rb
Rails.application.routes.draw do
  mount GraphdocRuby::Application, at: 'graphdoc'
end

# config/initializers/graphdoc.rb
GraphdocRuby.configure do |config|
  config.endpoint = 'https://graphql-pokemon.now.sh/'
end
```

```sh
$ bundle exec rails server --port 3000
$ open http://0.0.0.0:3000/graphdoc
```

## Configuration

```ruby
GraphdocRuby.configure do |config|
  # :endpoint
  #
  # Required: <String>
  # GraphQL endpoint url or dumped schema.json path.
  # 
  # Example
  #   config.endpoint = 'https://your-application.com/graphql'
  #   config.endpoint = Rails.root.join('tmp', 'graphql', 'schema.json')

  # :executable_path
  #
  # Optional: <String>
  # Executable path of `graphdoc`.
  # (default: `Bundler.which('graphdoc')`)
  #
  # Example
  #   config.executable_path = Rails.root.join('node_modules', '.bin', 'graphdoc')

  # :output_directory
  #
  # Optional: <String>
  # Output path for `graphdoc`. If you disabled run_time_generation, this value must be customized.
  # NOTE: Do not assign private directory because output_directory folders are served via rack application.
  # (default: `File.join(Dir.mktmpdir, 'graphdoc')`)
  #
  # Example
  #   config.output_directory = Rails.root.join('tmp', 'graphdoc')

  # :overwrite
  # Optional: <Boolean>
  # Overwrite files if generated html already exist.
  # (default: true)
  #
  # Example
  #   config.overwrite = false

  # :run_time_generation
  # Optional: <Boolean>
  # Generate html with graphdoc on the first access.
  # (default: true)
  # 
  # Example
  #   config.run_time_generation = Rails.env.development?

  # :graphql_context
  #
  # Optional: <Proc>
  # Context of your graphql.
  # (default: -> {})
  #   config.graphql_context = -> { { 'Authorization' => "Token #{ENV['GITHUB_ACCESS_TOKEN']}", 'User-Agent' => 'graphdoc-client' } }

  # :graphql_query
  #
  # Optional: <Proc>
  # Query of your graphql.
  # (default: -> {})
  #   config.graphql_query = -> { { 'token' => ENV['SECRET_API_TOKEN'] } }

  # ===
  # Integrated with [graphql-ruby](https://github.com/rmosolgo/graphql-ruby)
  # ===
  #
  # :schema_name
  #
  # Optional: <String>
  # Schema name of your graphql-ruby. It is necessary when generating schema.json.
  # (default: nil)
  #
  # Example
  #   config.schema_name = 'MyApplicationSchema'
end
```

### Example Configuration

#### Github

```ruby
GraphdocRuby.configure do |config|
  # Github
  config.endpoint = 'https://api.github.com/graphql'

  config.graphql_context = -> {
    {
      'Authorization' => "bearer #{ENV['GITHUB_ACCESS_TOKEN']}",
      'User-Agent' => 'my-client',
    }
  }
end
```

#### Your Rails product

```ruby
# config/routes.rb
Rails.application.routes.draw do
  namespace :admin do
    mount GraphdocRuby::Application, at: 'graphdoc'
  end
end

# config/initializers/graphdoc.rb
GraphdocRuby.configure do |config|
  config.endpoint = Rails.root.join('tmp', 'graphql', 'schema.json')
  config.output_directory = Rails.root.join('tmp', 'graphdoc').to_s
  config.schema_name = 'MyApplicationSchema'
  config.run_time_generation = Rails.env.development?
end

# Capfile
namespace :deploy do
  after :generate_graphdoc do
    within release_path do
      # Generate schema.json from MyApplicationSchema
      execute :rake, 'graphdoc:dump_schema'

      # Generate html with graphdoc from schema.json
      execute :rake, 'graphdoc:generate'
    end
  end

  after :publishing, :generate_graphdoc
end
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/alpaca-tc/graphdoc-ruby.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
