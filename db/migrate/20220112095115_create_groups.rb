class CreateGroups < ActiveRecord::Migration[7.0]
  def change
    create_table :groups do |t|
      t.string :name
      t.text :description
      t.string :access_code
      t.integer :group_type
      t.integer :created_by
      t.datetime :deleted_at

      t.timestamps
    end
  end
end
