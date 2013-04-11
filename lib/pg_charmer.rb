require 'pry'
require 'active_record'
require 'pg_charmer/connection_handler'

module PgCharmer
  mattr_accessor :default_connection
  mattr_accessor :transaction_connection
  mattr_accessor :force_connection

  # Setup defaults
  self.default_connection = :master
  self.transaction_connection = :master
  self.force_connection = nil

  def self.on(connection)
    self.connection_stack << connection
    begin
      yield
    ensure
      self.connection_stack.pop
    end
  end

  def self.connection_stack
    Thread.current[:pg_charmer_connection_stack] ||= []
  end

  # Used by use_db_connection. Cleared in an after_filter.
  def self.overwritten_default_connections
    Thread.current[:pg_charmer_overwritten_default_connections] ||= {}
  end
end

if Rails::VERSION::MAJOR == 4 and Rails::VERSION::MINOR == 0
  PgCharmer::ConnectionSpecificationResolver = ActiveRecord::ConnectionAdapters::ConnectionSpecification::Resolver
  ActiveRecord::Base.default_connection_handler = PgCharmer::ConnectionHandler.new
elsif Rails::VERSION::MAJOR == 3 and Rails::VERSION::MINOR == 2
  PgCharmer::ConnectionSpecificationResolver = ActiveRecord::Base::ConnectionSpecification::Resolver
  ActiveRecord::Base.connection_handler = PgCharmer::ConnectionHandler.new
else
  abort "PgCharmer doesn't support Rails version #{Rails.version}"
end

ActiveRecord::Base.instance_eval do
  class_attribute :default_connection

  # disable Model.establish_connection
  def establish_connection(*args)
    # This would be the only place Model.connection_handler.establish_connection is called.
    nil
  end

  # a transaction runs on PgCharmer.transaction_connection or on the :on option
  def transaction(options = {}, &block)
    if connection = (options.delete(:on) || PgCharmer.transaction_connection)
      PgCharmer.on(connection) { super }
    else
      super
    end
  end
end

ActionController::Base.instance_eval do
  def use_db_connection(connection, args)
    klasses = args.delete(:for).map { |klass| if klass.is_a? String then klass else klass.name end }
    before_filter(args) do |controller, &block|
      klasses.each do |klass|
        PgCharmer.overwritten_default_connections[klass] = connection
      end
    end
  end

  after_filter do
    PgCharmer.overwritten_default_connections.clear
  end
end
