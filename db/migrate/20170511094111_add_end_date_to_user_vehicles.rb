class AddEndDateToUserVehicles < ActiveRecord::Migration[5.0]
  def change
    add_column :user_vehicles, :end_date, :date
  end
end
