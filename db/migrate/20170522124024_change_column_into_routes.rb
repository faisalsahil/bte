class ChangeColumnIntoRoutes < ActiveRecord::Migration[5.0]
  def change
    # remove_column :routes, :area_id
    add_column    :routes, :area_ids, :text, array: true
  end
end
