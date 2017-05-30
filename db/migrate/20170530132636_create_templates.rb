class CreateTemplates < ActiveRecord::Migration[5.0]
  def change
    create_table :templates do |t|
      t.text :html
      t.string :subject
      t.string :from_email
      t.string :cc
      t.boolean :is_deleted, default: false

      t.timestamps
    end
  end
end
