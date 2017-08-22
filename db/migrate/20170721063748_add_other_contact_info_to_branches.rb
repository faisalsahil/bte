  class AddOtherContactInfoToBranches < ActiveRecord::Migration[5.0]
  def change
    add_column :branches, :contact_name1,  :string
    add_column :branches, :contact_email1, :string
    add_column :branches, :contact_phone1, :string
  end
end
