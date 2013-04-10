class Bar < ActiveRecord::Base
  self.table_name = 'test_bars'

  has_many :foos
end
