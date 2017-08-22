class AddSiteIdToRoutes < ActiveRecord::Migration[5.0]
  def change
    add_column :routes, :site_id, :integer
  end
end
