class CreateAssignments < ActiveRecord::Migration[5.0]
  def change
    create_table :assignments do |t|
      t.date :assigned_at
      t.integer :driver_id
      t.integer :helper_id
      t.integer :vehicle_id
      t.integer :route_id

      t.timestamps
    end
  end
end
