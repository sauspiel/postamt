# Drop in replacement for db-charmer
begin
  require 'db-charmer'
rescue LoadError
end
if defined? DbCharmer
  raise "Can't use db-charmer with pg_charmer"
end
require 'pg_charmer'

module DbCharmer
 def self.enable_controller_magic!
   nil
 end
end

ActiveRecord::Base.instance_eval do
  def db_magic(*args)
    puts "ignoring db_magic"
  end
end

ActionController::Base.instance_eval do
  def force_slave_reads(*args)
    around_filter(*args) do |controller, &block|
      PgCharmer.on(:slave) { block.call }
    end
  end
end