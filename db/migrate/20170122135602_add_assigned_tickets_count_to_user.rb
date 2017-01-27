class AddAssignedTicketsCountToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :assigned_tickets_count, :integer
  end
end
