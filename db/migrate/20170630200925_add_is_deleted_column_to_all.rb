class AddIsDeletedColumnToAll < ActiveRecord::Migration[5.0]
  def change
    add_column :areas, :is_deleted, :boolean, default: false
    add_column :branches, :is_deleted, :boolean, default: false
    add_column :cities, :is_deleted, :boolean, default: false
    add_column :companies, :is_deleted, :boolean, default: false
    add_column :food_types, :is_deleted, :boolean, default: false
    add_column :storage_types, :is_deleted, :boolean, default: false
    add_column :states, :is_deleted, :boolean, default: false
    add_column :vehicles, :is_deleted, :boolean, default: false
    add_column :routes, :is_deleted, :boolean, default: false
    add_column :assignments, :is_deleted, :boolean, default: false
  end
end
