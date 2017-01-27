class AddAssigneeIdToTicket < ActiveRecord::Migration[5.0]
  def change
    add_column :tickets, :assignee_id, :integer
    add_index :tickets, :assignee_id
  end
end
e