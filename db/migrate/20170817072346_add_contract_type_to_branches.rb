class AddContractTypeToBranches < ActiveRecord::Migration[5.0]
  def change
    add_column :branches, :contract_type, :string
  end
end
