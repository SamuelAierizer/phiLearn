class CreateMemberships < ActiveRecord::Migration[7.0]
  def change
    create_table :members do |t|
      t.integer :uid
      t.integer :memable_id
      t.integer :memable_type
      t.integer :mem_type

      t.timestamps
    end
  end
end
