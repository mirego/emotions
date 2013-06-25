$:.unshift File.expand_path('../../lib', __FILE__)

require 'rspec'
require 'sqlite3'

require 'emotions'

# Require our macros and extensions
Dir[File.expand_path('../../spec/support/macros/*.rb', __FILE__)].map(&method(:require))

# Inject our methods into ActiveRecord (like our railtie does)
ActiveRecord::Base.class_eval(&Emotions.inject_into_active_record)

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

  config.after(:each) do
    # Make sure we remove our test database file
    cleanup_database
  end
end
