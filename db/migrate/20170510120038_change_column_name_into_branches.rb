class ChangeColumnNameIntoBranches < ActiveRecord::Migration[5.0]
  def change
    rename_column :branches, :full_address, :address
  end
end
