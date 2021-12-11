class CreateTopics < ActiveRecord::Migration[6.1]
  def change
    create_table :topics do |t|
      t.string :name
      t.text :description
      t.integer :last_poster
      t.datetime :last_post_at
      t.integer :forum_id
      t.integer :owner_id

      t.timestamps
    end
  end
end
