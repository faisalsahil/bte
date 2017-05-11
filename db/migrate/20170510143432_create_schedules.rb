class CreateSchedules < ActiveRecord::Migration[5.0]
  def change
    create_table :schedules do |t|
      t.date :scheduled_at

      t.timestamps
    end
  end
end
