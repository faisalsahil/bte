class AddSiteIdToVehicles < ActiveRecord::Migration[5.0]
  def change
    add_column :vehicles, :site_id, :integer
  end
end
