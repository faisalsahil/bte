class AddSiteIdToAssignments < ActiveRecord::Migration[5.0]
  def change
    add_column :assignments, :site_id, :integer
  end
end
