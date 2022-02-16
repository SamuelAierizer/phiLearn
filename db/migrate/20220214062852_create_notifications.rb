class CreateNotifications < ActiveRecord::Migration[7.0]
  def change
    create_table :notifications do |t|
      t.integer :notif_type
      t.string :message
      t.integer :status
      t.integer :user_id

      t.timestamps
    end
  end
end
