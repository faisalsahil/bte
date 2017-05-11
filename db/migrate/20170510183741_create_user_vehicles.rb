class CreateUserVehicles < ActiveRecord::Migration[5.0]
  def change
    create_table :user_vehicles do |t|
      t.integer :user_id
      t.integer :vehicle_id
      t.date :assigned_date
      t.boolean :is_deleted, default: false

      t.timestamps
    end
  end
end
