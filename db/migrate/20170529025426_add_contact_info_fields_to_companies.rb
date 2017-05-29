class AddContactInfoFieldsToCompanies < ActiveRecord::Migration[5.0]
  def change
    add_column :companies, :contact_name, :string
    add_column :companies, :contact_email, :string
    add_column :companies, :contact_phone, :string
    add_column :companies, :company_status, :string, default: AppConstants::VISIT
    add_column :companies, :number_of_outlets, :integer
  end
end
