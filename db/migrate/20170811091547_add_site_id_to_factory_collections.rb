class AddSiteIdToFactoryCollections < ActiveRecord::Migration[5.0]
  def change
    add_column :factory_collections, :site_id, :integer
  end
end
