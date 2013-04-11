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
  self.force_connection = :master if Rails.env.development?

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
end

ActiveRecord::Base.instance_eval do
  class_attribute :default_connection

  self.default_connection_handler = PgCharmer::ConnectionHandler.new

  # disable Model.establish_connection
  def establish_connection(*args)
    # This would be the only place Model.connection_handler.establish_connection is called.
    nil
  end

  # a transaction runs on PgCharmer.connection_for_transactions or on
  # the :on option
  def transaction(options = {}, &block)
    if connection = (options.delete(:on) || PgCharmer.transaction_connection)
      PgCharmer.on(connection) { super }
    else
      super
    end
  end
end
