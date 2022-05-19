class CreateLectures < ActiveRecord::Migration[6.1]
  def change
    create_table :lectures do |t|
      t.string :name
      t.text :description
      t.integer :course_id
      t.datetime :deleted_at

      t.timestamps
    end
    
    add_index :lectures, :course_id
  end
end
