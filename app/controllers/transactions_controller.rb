class TransactionsController < ApplicationController
  
  def payment
    @branch     = Branch.find_by_id(params[:branch_id])
    @transaction = @branch.transactions.build
    
    @route_ids = Assignment.where.not(assignment_status: AppConstants::ACTIVE).pluck(:route_id)
    @total     = RouteBranch.where(branch_id: @branch.id, route_id: @route_ids).sum('quantity * price')
    @paid      = Transaction.where(branch_id: @branch.id).sum(:amount) || 0
  end
  
  def create_payment
    @branch      = Branch.find_by_id(params[:branch_id])
    @transaction = @branch.transactions.build(params_transaction)
    if @branch && params[:transaction][:amount].to_f <= params[:transaction][:balance].to_f
      @transaction.save!
      flash[:notice] = 'Transaction successful.'
      redirect_to billings_path
    else
      flash[:danger] = 'Amount should be less than the balance'
      @route_ids = Assignment.where.not(assignment_status: AppConstants::ACTIVE).pluck(:route_id)
      @total     = RouteBranch.where(branch_id: @branch.id, route_id: @route_ids).sum('quantity * price')
      @paid      = Transaction.where(branch_id: @branch.id).sum(:amount) || 0
      render :payment
    end
  end
  
  
  
  
  private
  def params_transaction
    params.require(:transaction).permit(:billing_id, :transaction_date, :amount, :balance)
  end
end
