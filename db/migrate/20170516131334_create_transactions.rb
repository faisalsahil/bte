class CreateTransactions < ActiveRecord::Migration[5.0]
  def change
    create_table :transactions do |t|
      t.integer :billing_id
      t.float :amount
      t.date :transaction_date

      t.timestamps
    end
  end
end
