class AddCountryNameToProductSales < ActiveRecord::Migration[5.0]
  def change
    add_column :product_sales, :country_name, :string
    add_column :product_sales, :country, :string
  end
end
