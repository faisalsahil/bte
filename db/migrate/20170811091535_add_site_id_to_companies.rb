class AddSiteIdToCompanies < ActiveRecord::Migration[5.0]
  def change
    add_column :companies, :site_id, :integer
  end
end
