$:.unshift File.join(File.dirname(__FILE__), *%w[.. lib])

require 'rspec'
require 'sqlite3'
require 'database_cleaner'

require 'emotions'

# Require our macros and extensions
Dir[File.expand_path('../../spec/support/macros/*.rb', __FILE__)].map(&method(:require))
Dir[File.expand_path('../../spec/support/extensions/*.rb', __FILE__)].map(&method(:require))

database_file = File.join(File.dirname(__FILE__), 'test.db')

RSpec.configure do |config|
  # Include our macros
  config.include DatabaseMacros
  config.include ModelMacros

  config.before(:suite) do
    # Establish the connection
    SQLite3::Database.new FileUtils.touch(database_file).first
    ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: database_file)

    # Silence everything
    ActiveRecord::Base.logger = ActiveRecord::Migration.verbose = false

    # Run our migration
    load File.join(File.dirname(__FILE__), '../lib/generators/emotions/templates/migration.rb')
    AddEmotions.new.up

    # Use truncation to clean our test database
    DatabaseCleaner.strategy = :truncation
  end

  config.after(:suite) do
    # Remove our test database
    FileUtils.rm(database_file) if File.exists?(database_file)
  end

  config.before(:each) { DatabaseCleaner.start }
  config.after(:each) { DatabaseCleaner.clean }
end
