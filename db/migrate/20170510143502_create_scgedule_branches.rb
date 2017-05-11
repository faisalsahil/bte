class CreateScgeduleBranches < ActiveRecord::Migration[5.0]
  def change
    create_table :scgedule_branches do |t|
      t.integer :schedule_id
      t.integer :branch_id
      t.integer :vehicle_id

      t.timestamps
    end
  end
end
