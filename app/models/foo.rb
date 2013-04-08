class Foo < ActiveRecord::Base
  self.table_name = 'test_foos'

  belongs_to :bar
end
