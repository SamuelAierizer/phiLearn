class CreateComments < ActiveRecord::Migration[6.1]
  def change
    create_table :comments do |t|
      t.text :body
      t.integer :target_type
      t.integer :target_id
      t.integer :parent_id
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
