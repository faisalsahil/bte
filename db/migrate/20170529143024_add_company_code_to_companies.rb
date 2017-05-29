class AddCompanyCodeToCompanies < ActiveRecord::Migration[5.0]
  def change
    add_column :companies, :company_code, :integer, default: 0
  end
end
