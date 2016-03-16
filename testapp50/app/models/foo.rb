class Foo < ActiveRecord::Base
  self.default_connection = :slave

  belongs_to :bar
end
