class RemoveAndColumnToTransactions < ActiveRecord::Migration[5.0]
  def change
    remove_column :transactions, :billing_id
    add_column    :transactions, :branch_id, :integer
  end
end
