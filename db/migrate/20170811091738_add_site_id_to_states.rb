class AddSiteIdToStates < ActiveRecord::Migration[5.0]
  def change
    add_column :states, :site_id, :integer
  end
end
