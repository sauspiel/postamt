require 'pry'
require 'active_record'
require 'pg_charmer/connection_handler'

module PgCharmer
  def self.default_connection
    ActiveRecord::Base.default_connection
  end

  def self.default_connection=(default_connection)
    ActiveRecord::Base.default_connection = default_connection
  end
end

ActiveRecord::Base.default_connection_handler = PgCharmer::ConnectionHandler.new

ActiveRecord::Base.instance_eval do
  class_attribute :default_connection
  self.default_connection = Rails.env

  # disable establish_connection
  def establish_connection(*args)
    puts "Stubbed out establish_connection"
    nil
  end
end

AR = ActiveRecord
ARB = AR::Base
DCH = ARB.default_connection_handler
