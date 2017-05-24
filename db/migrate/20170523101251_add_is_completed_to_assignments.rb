class AddIsCompletedToAssignments < ActiveRecord::Migration[5.0]
  def change
    add_column :assignments, :is_completed, :boolean, default: false
    add_column :routes,      :is_completed, :boolean, default: false
  end
end
