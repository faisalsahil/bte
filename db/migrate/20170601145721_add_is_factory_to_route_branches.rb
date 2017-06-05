class AddIsFactoryToRouteBranches < ActiveRecord::Migration[5.0]
  def change
    add_column :route_branches, :is_factory, :boolean, default: false
    add_column :route_branches, :factory_collection_id, :integer
  end
end
