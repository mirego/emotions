module DatabaseMacros
  # Run migrations in the test database
  def run_migration(&block)
    # Create a new migration class
    klass = Class.new(ActiveRecord::Migration)

    # Create a new `up` that executes the argument
    klass.define_method(:up) { self.instance_exec(&block) }

    # Create a new instance of it and execute its `up` method
    klass.new.up
  end
end
