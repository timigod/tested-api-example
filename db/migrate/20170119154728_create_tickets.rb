class CreateTickets < ActiveRecord::Migration[5.0]
  def change
    create_table :tickets do |t|
      t.string :subject
      t.text :body
      t.integer :user_id
      t.integer :status

      t.index ["user_id"]
      t.index ["status"]
      t.timestamps
    end
  end
end
