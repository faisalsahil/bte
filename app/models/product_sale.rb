class ProductSale < ApplicationRecord
  mount_uploader :attachment, ImageUploader


  def self.to_csv(product_sales, columns = {})
    @columns = columns.split(',')
    CSV.generate do |csv|
      csv << @columns
      product_sales.each do |product_sale|
        ar = []
        ar << product_sale.sale_date.to_date.strftime('%d/%m/%Y') if @columns.include? 'date'
        ar << product_sale.country_name if @columns.include? 'country_name'
        ar << product_sale.gd_number if @columns.include? 'gd_number'
        ar << product_sale.quantity if @columns.include? 'quantity'
        ar << product_sale.remarks if @columns.include? 'remarks'
        csv << ar
      end
    end
  end
end
