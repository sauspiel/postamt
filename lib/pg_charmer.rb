require 'pg_charmer/connection_handler'
require 'pg_charmer/railtie' if defined?(Rails)

module PgCharmer
  # Called by PgCharmer::Railtie after active_record.initialize_database or manually if
  # ActiveRecord is used standalone without Rails.
  def self.hook_active_record!
    ActiveRecord::Base.default_connection_handler = PgCharmer::ConnectionHandler.new
  end
end

