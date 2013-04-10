class Bar < ActiveRecord::Base
  self.table_name = 'test_bars'

  self.default_connection = "#{Rails.env}"

  has_many :foos
end
