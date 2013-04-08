class CreateBars < ActiveRecord::Migration
  def change
    create_table :test_bars do |t|
      t.text :message

      t.timestamps
    end
  end
end
