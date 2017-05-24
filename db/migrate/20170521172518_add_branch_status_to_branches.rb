class AddBranchStatusToBranches < ActiveRecord::Migration[5.0]
  def change
    add_column :branches, :branch_status, :string
  end
end
