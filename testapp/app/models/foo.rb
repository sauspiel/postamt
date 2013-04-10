class Foo < ActiveRecord::Base
  self.default_connection = :slave
  self.table_name = 'test_foos'

  belongs_to :bar
end
