class CreateBars < ActiveRecord::Migration
  def change
    create_table :bars do |t|
      t.text :message

      t.timestamps
    end
  end
end
