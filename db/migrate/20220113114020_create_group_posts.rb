class CreateGroupPosts < ActiveRecord::Migration[7.0]
  def change
    create_table :group_posts do |t|
      t.text :body
      t.integer :user_id
      t.integer :group_id
      t.integer :post_type
      t.integer :like_count
      t.datetime :deleted_at

      t.timestamps
    end

    add_column :comments, :like_count, :integer
  end
end
