class AddPositionIntoRouteBranches < ActiveRecord::Migration[5.0]
  def change
    add_column :route_branches, :position, :integer
  end
end
