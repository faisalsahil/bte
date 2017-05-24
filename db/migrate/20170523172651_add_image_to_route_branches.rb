class AddImageToRouteBranches < ActiveRecord::Migration[5.0]
  def change
    add_column :route_branches, :image, :string
  end
end
