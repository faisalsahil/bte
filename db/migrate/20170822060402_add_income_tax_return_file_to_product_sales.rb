class AddIncomeTaxReturnFileToProductSales < ActiveRecord::Migration[5.0]
  def change
    add_column :product_sales, :income_tax_return_file, :string
  end
end
