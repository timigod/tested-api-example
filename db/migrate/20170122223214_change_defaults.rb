class ChangeDefaults < ActiveRecord::Migration[5.0]
  def change
    change_column :users, :role, :integer, default: 0
    change_column :tickets, :status, :integer, default: 0
  end
end
