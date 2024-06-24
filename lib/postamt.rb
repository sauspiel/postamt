require 'action_controller'
require 'active_record'
require 'postamt/connection_handler'
require 'postamt/railtie'

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

  # Called by Postamt::Railtie
  def self.hook!
    if Rails::VERSION::MAJOR == 4 and Rails::VERSION::MINOR <= 2
      ActiveRecord::Base.default_connection_handler = Postamt::ConnectionHandler.new
    elsif Rails::VERSION::MAJOR == 3 and Rails::VERSION::MINOR == 2
      ActiveRecord::Base.connection_handler = Postamt::ConnectionHandler.new
    end

    ActiveRecord::Base.instance_eval do
      class_attribute :default_connection, :transaction_connection

      # disable Model.establish_connection
      def establish_connection(*args)
        # This would be the only place Model.connection_handler.establish_connection is called.
        nil
      end

      # a transaction runs on Postamt.transaction_connection or on the :on option
      def transaction(options = {}, &block)
        if connection = (options.delete(:on) || transaction_connection || Postamt.transaction_connection)
          Postamt.on(connection) { super }
        else
          super
        end
      end
    end

    ActionController::Base.instance_eval do
      def use_db_connection(connection, args)
        klass_names = args.delete(:for)
        if klass_names == :all
          around_filter(args) do |controller|
            Postamt.on(connection) { yield }
          end
        else
          default_connections = {}
          klass_names.each do |klass_name|
            default_connections[klass_name] = connection
          end

          before_filter(args) do |controller|
            Postamt.overwritten_default_connections.merge!(default_connections)
          end
        end
      end

      after_filter do
        Postamt.overwritten_default_connections.clear
      end
    end

    ActiveRecord::LogSubscriber.prepend Postamt::LogSubscriber
    ActiveRecord::Relation.prepend Postamt::Relation
  end

  module LogSubscriber
    extend ActiveSupport::Concern

    def sql(event)
      @postamt_connection_name = ObjectSpace._id2ref(event.payload[:connection_id]).instance_variable_get(:@config)[:username]
      super
    end

    def debug(msg)
      conn = @postamt_connection_name ? color("  [#{@postamt_connection_name}]", ActiveSupport::LogSubscriber::BLUE, true) : ''
      super(conn + msg)
    end
  end

  module Relation
    # Also make sure that actions that don't instantiate the model and
    # therefore don't call #save or #destroy run on master.
    # update_column calls update_all, delete calls delete_all, so we don't
    # have to monkey patch them.

    def delete_all(conditions = nil)
      if connection = (transaction_connection || Postamt.transaction_connection)
        Postamt.on(connection) { super }
      else
        super
      end
    end

    def update(updates)
      if connection = (transaction_connection || Postamt.transaction_connection)
        Postamt.on(connection) { super }
      else
        super
      end
    end
  end
end

