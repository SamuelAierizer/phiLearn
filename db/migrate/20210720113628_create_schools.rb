class CreateSchools < ActiveRecord::Migration[6.1]
  def change
    create_table :schools do |t|
      t.string :name
      t.string :subdomain

      t.timestamps
    end
    add_index :schools, :name, unique: true
  end
end
