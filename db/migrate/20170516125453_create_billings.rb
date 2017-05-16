class CreateBillings < ActiveRecord::Migration[5.0]
  def change
    create_table :billings do |t|
      t.integer :branch_id
      t.float :total
      t.float :paid
      t.float :balance

      t.timestamps
    end
  end
end
