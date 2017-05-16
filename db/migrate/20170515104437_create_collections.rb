class CreateCollections < ActiveRecord::Migration[5.0]
  def change
    create_table :collections do |t|
      t.date :collected_at
      t.integer :branch_id
      t.integer :vehicle_id
      t.float :quantity

      t.timestamps
    end
  end
end
