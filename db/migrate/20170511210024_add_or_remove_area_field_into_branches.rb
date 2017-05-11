class AddOrRemoveAreaFieldIntoBranches < ActiveRecord::Migration[5.0]
  def change
    remove_column :branches, :area
    add_column    :branches, :area_id, :integer
  end
end
