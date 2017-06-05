class BillingsController < ApplicationController
  before_action :set_billing, only: [:show, :edit, :update, :destroy]

  def index
    @route_ids    = Assignment.where.not(assignment_status: AppConstants::ACTIVE).pluck(:route_id)
    @branch_ids   = RouteBranch.where(route_id: @route_ids).pluck(:branch_id).uniq
    @branches     = Branch.where(id: @branch_ids).includes(:company)
    @transactions = Transaction.where(branch_id: @branch_ids)
  end
end
