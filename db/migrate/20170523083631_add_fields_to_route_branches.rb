class AddFieldsToRouteBranches < ActiveRecord::Migration[5.0]
  def change
    add_column :route_branches, :quantity, :float
    add_column :route_branches, :is_transferred, :boolean, default: false
    add_column :route_branches, :transfer_to,    :integer
    add_column :route_branches, :is_deleted,     :boolean, default: false
  end
end
