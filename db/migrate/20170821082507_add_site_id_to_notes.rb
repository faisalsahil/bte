class AddSiteIdToNotes < ActiveRecord::Migration[5.0]
  def change
    add_column :notes, :site_id, :integer
  end
end
