class CreateResources < ActiveRecord::Migration[6.1]
  def change
    create_table :resources do |t|
      t.string :name
      t.string :path
      t.integer :material_type
      t.integer :material_id

      t.timestamps
    end
  end
end
