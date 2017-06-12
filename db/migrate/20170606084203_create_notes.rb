class CreateNotes < ActiveRecord::Migration[5.0]
  def change
    create_table :notes do |t|
      t.integer :branch_id
      t.text :comment

      t.timestamps
    end
  end
end
