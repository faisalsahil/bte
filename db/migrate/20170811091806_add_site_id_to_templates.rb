class AddSiteIdToTemplates < ActiveRecord::Migration[5.0]
  def change
    add_column :templates, :site_id, :integer
  end
end
