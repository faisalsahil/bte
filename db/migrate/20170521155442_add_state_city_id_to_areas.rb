class AddStateCityIdToAreas < ActiveRecord::Migration[5.0]
  def change
    add_column :areas, :state_id, :integer
    add_column :areas, :city_id, :integer
  end
end
