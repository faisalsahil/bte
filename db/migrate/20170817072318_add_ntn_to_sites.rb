class AddNtnToSites < ActiveRecord::Migration[5.0]
  def change
    add_column :sites, :ntn, :string
  end
end
