class SetAssignedTicketsCountDefault < ActiveRecord::Migration[5.0]
  def change
    change_column_default :users, :assigned_tickets_count, default: 0
  end
end
