class CreateCourses < ActiveRecord::Migration[6.1]
  def change
    create_table :courses do |t|
      t.string :name
      t.text :description
      t.integer :owner_id
      t.datetime :deleted_at

      t.timestamps
    end

    add_index :courses, :name, unique: true
    add_index :courses, :owner_id
  end
end
