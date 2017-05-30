class CreateEmailHistories < ActiveRecord::Migration[5.0]
  def change
    create_table :email_histories do |t|
      t.integer :template_id
      t.text :html
      t.string :subject
      t.string :from_email
      t.string :cc

      t.timestamps
    end
  end
end
