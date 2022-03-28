class CreateEvents < ActiveRecord::Migration[7.0]
  def change
    create_table :events do |t|
      t.string :title
      t.text :description
      t.integer :color
      t.datetime :start
      t.datetime :finish
      t.integer :user_id

      t.datetime :deleted_at
      
      t.timestamps
    end
  end
end
