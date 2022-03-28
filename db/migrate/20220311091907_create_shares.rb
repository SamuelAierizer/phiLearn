class CreateShares < ActiveRecord::Migration[7.0]
  def change
    create_table :shares do |t|
      t.integer :user_id
      t.integer :shareable_id
      t.integer :shareable_type

      t.timestamps
    end

    add_index :shares, [:user_id, :shareable_id, :shareable_type], :unique => true
  end
end
