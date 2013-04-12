require 'action_controller'
require 'active_record'
require 'postamt/connection_handler'

module Postamt
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

  def self.configurations
    @configurations ||= begin
      input = ActiveRecord::Base.configurations[Rails.env]
      configs = input.select { |k, v| v.is_a? Hash }
      master_config = input.reject { |k, v| v.is_a? Hash }
      configs.each { |k, v| v.reverse_merge!(master_config) }
      configs['master'] = master_config
      configs
    end
  end

  def self.connection_stack
    Thread.current[:postamt_connection_stack] ||= []
  end

  # Used by use_db_connection. Cleared in an after_filter.
  def self.overwritten_default_connections
    Thread.current[:postamt_overwritten_default_connections] ||= {}
  end
end

if Rails::VERSION::MAJOR == 4 and Rails::VERSION::MINOR == 0
  Postamt::ConnectionSpecificationResolver = ActiveRecord::ConnectionAdapters::ConnectionSpecification::Resolver
  ActiveRecord::Base.default_connection_handler = Postamt::ConnectionHandler.new
elsif Rails::VERSION::MAJOR == 3 and Rails::VERSION::MINOR == 2
  Postamt::ConnectionSpecificationResolver = ActiveRecord::Base::ConnectionSpecification::Resolver
  ActiveRecord::Base.connection_handler = Postamt::ConnectionHandler.new
else
  abort "Postamt doesn't support Rails version #{Rails.version}"
end

ActiveRecord::Base.instance_eval do
  class_attribute :default_connection

  # disable Model.establish_connection
  def establish_connection(*args)
    # This would be the only place Model.connection_handler.establish_connection is called.
    nil
  end

  # a transaction runs on Postamt.transaction_connection or on the :on option
  def transaction(options = {}, &block)
    if connection = (options.delete(:on) || Postamt.transaction_connection)
      Postamt.on(connection) { super }
    else
      super
    end
  end
end

ActionController::Base.instance_eval do
  def use_db_connection(connection, args)
    default_connections = {}
    klass_names = args.delete(:for)
    klass_names.each do |klass_name|
      default_connections[klass_name] = connection
    end

    before_filter(args) do |controller|
      Postamt.overwritten_default_connections.merge!(default_connections)
    end
  end

  after_filter do
    Postamt.overwritten_default_connections.clear
  end
end
