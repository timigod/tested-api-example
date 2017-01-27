class AddTicketCategoryForeignKeys < ActiveRecord::Migration[5.0]
  def change
    add_column :tickets, :category_id, :integer
    add_index :tickets, :category_id
  end
end
