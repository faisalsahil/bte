class RemoveStateCityFromBranch < ActiveRecord::Migration[5.0]
  def change
    remove_column :branches, :state
    remove_column :branches, :city
  end
end
