class AddAreaFieldToBranches < ActiveRecord::Migration[5.0]
  def change
    add_column :branches, :area, :string
    add_column :branches, :branch_code, :string
  end
end
