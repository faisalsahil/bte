class AddAreaToRoutes < ActiveRecord::Migration[5.0]
  def change
    remove_column :routes, :area_ids
    add_column :routes, :areas, :text, array:true, default: []
  end
end
