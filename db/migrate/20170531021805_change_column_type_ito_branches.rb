class ChangeColumnTypeItoBranches < ActiveRecord::Migration[5.0]
  def change
    remove_column :branches, :branch_code
    add_column    :branches, :branch_code, :integer, default: 0
  end
end
