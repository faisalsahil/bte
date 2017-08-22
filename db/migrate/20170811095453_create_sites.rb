class CreateSites < ActiveRecord::Migration[5.0]
  def change
    create_table :sites do |t|
      t.string :name
      t.boolean :is_automate_process, default: false

      t.timestamps
    end
  end
end
