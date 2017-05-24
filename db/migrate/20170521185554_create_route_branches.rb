class CreateRouteBranches < ActiveRecord::Migration[5.0]
  def change
    create_table :route_branches do |t|
      t.integer :route_id
      t.integer :branch_id

      t.timestamps
    end
  end
end
