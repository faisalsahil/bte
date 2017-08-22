class AddCollectedDateToRouteBranches < ActiveRecord::Migration[5.0]
  def change
    add_column :route_branches, :collected_date, :date
  end
end
