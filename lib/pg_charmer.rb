require 'pry'
require 'pg_charmer/connection_handler'
require 'pg_charmer/railtie' if defined?(Rails)

module PgCharmer
  def self.default_connection
    ActiveRecord::Base.default_connection
  end

  def self.default_connection=(default_connection)
    ActiveRecord::Base.default_connection = default_connection
  end

  # Called by PgCharmer::Railtie after active_record.initialize_database or manually if
  # ActiveRecord is used standalone without Rails.
  def self.install!
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

    Kernel.const_set(:DCH, ARB.default_connection_handler)
  end
end

AR = ActiveRecord
ARB = AR::Base
