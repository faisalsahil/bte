class AddStorateTypeIdToBranches < ActiveRecord::Migration[5.0]
  def change
    add_column :branches, :storage_type_id, :integer
    add_column :branches, :food_type_id,    :integer
    add_column :branches, :city_id, :integer
    add_column :branches, :state_id, :integer
    add_column :branches, :rate_per_kg, :float
    
    remove_column :branches, :type_of_establishment
    remove_column :branches, :storage_type
  end
end
