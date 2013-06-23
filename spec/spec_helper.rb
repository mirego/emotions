$:.unshift File.join(File.dirname(__FILE__), *%w[.. lib])

require 'rspec'
require 'sqlite3'

require 'emotions'

# Require our macros and extensions
Dir[File.expand_path('../../spec/support/macros/*.rb', __FILE__)].map(&method(:require))
Dir[File.expand_path('../../spec/support/extensions/*.rb', __FILE__)].map(&method(:require))

RSpec.configure do |config|
  # Include our macros
  config.include DatabaseMacros
  config.include ModelMacros

  config.before(:each) do
    # Create the SQLite database
    setup_database

    # Run our migration
    run_default_migration
  end
end
