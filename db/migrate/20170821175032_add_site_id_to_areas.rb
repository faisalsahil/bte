class AddSiteIdToAreas < ActiveRecord::Migration[5.0]
  def change
    add_column :areas, :site_id, :integer
  end
end
