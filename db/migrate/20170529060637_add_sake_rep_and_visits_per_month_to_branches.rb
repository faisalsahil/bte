class AddSakeRepAndVisitsPerMonthToBranches < ActiveRecord::Migration[5.0]
  def change
    add_column :branches, :representative, :integer
    add_column :branches, :visits_per_month, :integer
  end
end
