class Bar < ActiveRecord::Base
  self.table_name = 'test_bars'

  establish_connection "#{Rails.env}"

  has_many :foos
end
