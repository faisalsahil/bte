class CreateBranches < ActiveRecord::Migration[5.0]
  def change
    create_table :branches do |t|
      t.integer :company_id
      t.string :branch_name
      t.string :contact_name
      t.string :contact_email
      t.string :contact_phone
      t.integer :number_of_outlets
      t.string :type_of_establishment
      t.float :monthly_oil_used
      t.float :latitude
      t.float :longitude
      t.string :storage_type
      t.text :full_address

      t.timestamps
    end
  end
end
