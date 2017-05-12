class CreateScheduleBranches < ActiveRecord::Migration[5.0]
  def change
    create_table :schedule_branches do |t|
      t.integer :vehicle_id
      t.integer :branch_id
      t.string :schedule_day

      t.timestamps
    end
  end
end
