class Foo < ActiveRecord::Base
  self.table_name = 'test_foos'

  belongs_to :bar

  self.default_connection = "#{Rails.env}_slave1"
end
