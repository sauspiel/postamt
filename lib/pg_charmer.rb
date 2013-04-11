require 'pry'
require 'active_record'
require 'pg_charmer/connection_handler'

module PgCharmer
  mattr_accessor :default_connection
  mattr_accessor :force_connection

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

  def transaction(options = {}, &block)
    PgCharmer.connection_stack << :master
    begin
      super
    ensure
      PgCharmer.connection_stack.pop
    end
  end
end

AR = ActiveRecord
ARB = AR::Base
DCH = ARB.default_connection_handler
