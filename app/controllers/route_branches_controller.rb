class RouteBranchesController < ApplicationController
  
  def sort
    route_branches = params[:route_branch]
    
    route_branches&.each.with_index do |route_branch_id, index|
      object = RouteBranch.where(id: route_branch_id).try(:first)
      object.position = index + 1
      object.save!
    end
  end
end
