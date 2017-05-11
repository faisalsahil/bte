class AddAddressFieldsToBranch < ActiveRecord::Migration[5.0]
  def change
    add_column :branches, :street, :string
    add_column :branches, :city,   :string
    add_column :branches, :state,  :string
    add_column :branches, :zip,    :string
  end
end
