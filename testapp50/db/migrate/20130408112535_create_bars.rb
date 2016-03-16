class CreateBars < ActiveRecord::Migration[5.0]
  def change
    create_table :bars do |t|
      t.text :message

      t.timestamps
    end
  end
end
