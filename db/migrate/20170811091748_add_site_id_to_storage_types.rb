class AddSiteIdToStorageTypes < ActiveRecord::Migration[5.0]
  def change
    add_column :storage_types, :site_id, :integer
  end
end
