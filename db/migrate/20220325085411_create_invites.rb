class CreateInvites < ActiveRecord::Migration[7.0]
  def change
    create_table :invites do |t|
      t.integer :sender_id
      t.integer :reciever_id
      t.string :message
      t.integer :inviteable_id
      t.integer :inviteable_type

      t.timestamps
    end
  end
end
