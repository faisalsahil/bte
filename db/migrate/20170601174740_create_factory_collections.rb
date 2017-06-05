class CreateFactoryCollections < ActiveRecord::Migration[5.0]
  def change
    create_table :factory_collections do |t|
      t.date :date
      t.float :quantity

      t.timestamps
    end
  end
end
