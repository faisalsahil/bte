class AddPriceFieldToRouteBranches < ActiveRecord::Migration[5.0]
  def change
    add_column :route_branches, :price, :float
    add_column :route_branches, :factory_image, :string
  end
end
