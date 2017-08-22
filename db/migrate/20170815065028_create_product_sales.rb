class CreateProductSales < ActiveRecord::Migration[5.0]
  def change
    create_table :product_sales do |t|
      t.date :sale_date
      t.string :country
      t.string :gd_number
      t.float :quantity
      t.string :attachment
      t.text :remarks
      t.float :stock_in_hand
      t.integer :site_id

      t.timestamps
    end
  end
end
