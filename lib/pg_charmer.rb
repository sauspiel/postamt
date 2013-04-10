require 'pry'
require 'pg_charmer/connection_handler'
require 'pg_charmer/railtie' if defined?(Rails)

module PgCharmer
  # Called by PgCharmer::Railtie after active_record.initialize_database or manually if
  # ActiveRecord is used standalone without Rails.
  def self.hook_active_record!
    ActiveRecord::Base.default_connection_handler = PgCharmer::ConnectionHandler.new
    def (ActiveRecord::Base).establish_connection(*args)
      nil
    end
    Kernel.const_set(:DCH, ARB.default_connection_handler)
  end
end

AR = ActiveRecord
ARB = AR::Base
