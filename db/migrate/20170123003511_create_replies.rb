class CreateReplies < ActiveRecord::Migration[5.0]
  def change
    create_table :replies do |t|
      t.integer :ticket_id
      t.text :body
      t.integer :sender_id

      t.timestamps
    end
  end
end
