class AddStatusFieldToAssignments < ActiveRecord::Migration[5.0]
  def change
    add_column :assignments, :assignment_status, :string, default: 'active'
  end
end
