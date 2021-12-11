class AddUserPostLikes < ActiveRecord::Migration[6.1]
  def change
    create_table :likes do |t|
      t.integer :user_id
      t.integer :likeable_id
      t.integer :likeable_type

      t.timestamps
    end
    add_index :likes, :user_id
    add_index :likes, [:user_id, :likeable_id, :likeable_type], :unique => true

    add_column :posts, :like_count, :integer, :default => 0
    add_column :topics, :is_blocked, :boolean, :default => false
  end
end
