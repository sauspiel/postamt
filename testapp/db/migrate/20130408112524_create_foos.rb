class CreateFoos < ActiveRecord::Migration
  def change
    create_table :test_foos do |t|
      t.integer :bar_id

      t.timestamps
    end
  end
end
