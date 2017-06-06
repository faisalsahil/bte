class AddCommentFieldToRouteBranches < ActiveRecord::Migration[5.0]
  def change
    add_column :route_branches, :comment, :text
  end
end
