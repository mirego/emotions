$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

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

  # Disable `should` syntax
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.before(:each) do
    # Create the SQLite database
    setup_database

    # Run our migration
    run_default_migration

    # Create Emotion model
    spawn_model 'Emotion', ActiveRecord::Base do
      acts_as_emotion
    end
  end

  config.after(:each) do
    # Make sure we remove our test database file
    cleanup_database
  end
end
