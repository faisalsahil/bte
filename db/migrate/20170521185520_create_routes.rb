class CreateRoutes < ActiveRecord::Migration[5.0]
  def change
    create_table :routes do |t|
      t.integer :state_id
      t.integer :city_id
      t.integer :area_id

      t.timestamps
    end
  end
end
