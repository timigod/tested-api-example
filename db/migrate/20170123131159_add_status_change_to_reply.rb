class AddStatusChangeToReply < ActiveRecord::Migration[5.0]
  def change
    add_column :replies, :status_change, :boolean, default: false
    add_index :replies, :status_change
  end
end
