class AddCompleteNoteFieldToNotes < ActiveRecord::Migration[5.0]
  def change
    add_column :notes, :completed_notes, :text
    add_column :notes, :is_completed, :boolean, defaut: false
  end
end
