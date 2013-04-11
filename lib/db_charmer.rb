# Drop in replacement for db-charmer
if defined? DbCharmer
  raise "Can't use db-charmer with pg_charmer"
end
require 'pg_charmer'

module DbCharmer
 def self.enable_controller_magic!
   puts "ignoring enable_controller_magic!"
 end
end

ActiveRecord::Base.instance_eval do
  def db_magic(*args)
    puts "ignoring db_magic"
  end
end

ActionController::Base.instance_eval do
  def force_slave_reads(*args)
    puts "ignoring force_slave_reads"
  end
end
