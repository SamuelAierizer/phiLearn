class CreatePosts < ActiveRecord::Migration[6.1]
  def change
    create_table :posts do |t|
      t.text :content
      t.integer :topic_id
      t.integer :user_id
      t.integer :parent_id

      t.timestamps
    end
  end
end
