$LOAD_PATH << "." unless $LOAD_PATH.include?(".")
require 'logger'

begin
  require "rubygems"
  require "bundler"

  if Gem::Version.new(Bundler::VERSION) <= Gem::Version.new("0.9.5")
    raise RuntimeError, "Your bundler version is too old." +
      "Run `gem install bundler` to upgrade."
  end

  # Set up load paths for all bundled gems
  Bundler.setup
rescue Bundler::GemNotFound
  raise RuntimeError, "Bundler couldn't find some gems." +
    "Did you run \`bundle install\`?"
end

Bundler.require
require File.expand_path('../../lib/async_observer', __FILE__)

unless [].respond_to?(:freq)
  class Array
    def freq; inject Hash.new(0) { |e| k[e] += 1; k }; end
  end
end

begin
  RAILS_DEFAULT_LOGGER
rescue ArgumentError
  RAILS_DEFAULT_LOGGER = Logger.new(File.join(File.dirname(__FILE__), "debug.log"))
end

db_name = ENV['DB'] || 'sqlite3'
database_yml = File.expand_path('../database.yml', __FILE__)

if File.exists?(database_yml)
  active_record_configuration = YAML.load_file(database_yml)

  ActiveRecord::Base.configurations = active_record_configuration
  config = ActiveRecord::Base.configurations[db_name]

  begin
    ActiveRecord::Base.establish_connection(db_name)
    ActiveRecord::Base.connection
  rescue
    case db_name
    when /mysql/
      ActiveRecord::Base.establish_connection(config.merge('database' => nil))
      ActiveRecord::Base.connection.create_database(config['database'],  {:charset => 'utf8', :collation => 'utf8_unicode_ci'})
    when 'postgresql'
      ActiveRecord::Base.establish_connection(config.merge('database' => 'postgres', 'schema_search_path' => 'public'))
      ActiveRecord::Base.connection.create_database(config['database'], config.merge('encoding' => 'utf8'))
    end

    ActiveRecord::Base.establish_connection(config)
  end

  ActiveRecord::Base.logger = RAILS_DEFAULT_LOGGER
  ActiveRecord::Base.default_timezone = :utc

  ActiveRecord::Base.silence do
    ActiveRecord::Migration.verbose = false
    load(File.dirname(__FILE__) + '/schema.rb')
    load(File.dirname(__FILE__) + '/models.rb')
  end

else
  raise "Please create #{database_yml} first to configure your database. Take a look at: #{database_yml}.sample"
end

def clean_database!
  models = [AsyncModel]
  models.each do |model|
    ActiveRecord::Base.connection.execute "DELETE FROM #{model.table_name}"
  end
end

clean_database!

# RAILS_DEFAULT_LOGGER = Logger.new(STDOUT)
# def RAILS_DEFAULT_LOGGER.format_message(severity, timestamp, progname, msg)
#   " #{progname} -#{severity}: #{timestamp} (#{$$}) #{msg}\n"
# end
