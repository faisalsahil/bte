class AddSiteIdToFoodTypes < ActiveRecord::Migration[5.0]
  def change
    add_column :food_types, :site_id, :integer
  end
end
