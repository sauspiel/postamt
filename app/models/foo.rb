class Foo < ActiveRecord::Base
  self.table_name = 'test_foos'

  belongs_to :bar

  establish_connection "#{Rails.env}_slave1"

  def self.connection
    puts 'CCCCCCCCCC'
    #require 'pry' ; binding.pry
    super
  end
end
