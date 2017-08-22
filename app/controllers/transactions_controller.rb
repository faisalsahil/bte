class TransactionsController < ApplicationController
  load_and_authorize_resource
  
  def index
    @date   = params[:date]
    @branch = Branch.find_by_id(params[:branch_id])
    @transactions = @branch.transactions.order('transaction_date DESC')
  end

  def payment
    @branch     = Branch.find_by_id(params[:branch_id])
    @transaction = @branch.transactions.build
    @date = params[:date]
    # @route_ids = Assignment.where.not(assignment_status: AppConstants::ACTIVE).pluck(:route_id)
    @route_ids = Assignment.where('assignment_status != ? AND extract(month from assigned_at) = ?',AppConstants::ACTIVE, params[:date].to_date.month).pluck(:route_id)
    @total     = RouteBranch.where(branch_id: @branch.id, route_id: @route_ids).sum('quantity * price')
    @paid      = Transaction.where('branch_id = ? AND extract(month from transaction_date) = ?', @branch.id, params[:date].to_date.month).sum(:amount) || 0
  end
  
  def create_payment
    @branch = Branch.find_by_id(params[:branch_id])
    @date   = params[:transaction][:date]
    @transaction = @branch.transactions.build(params_transaction)
    if @branch && params[:transaction][:amount].to_f <= params[:transaction][:balance].to_f
      @transaction.save!
      flash[:notice] = 'Transaction successful.'
      redirect_to billings_path
    else
      flash[:danger] = 'Amount should be less than the balance'
      @route_ids = Assignment.where('assignment_status != ? AND extract(month from assigned_at) = ?',AppConstants::ACTIVE, params[:date].to_date.month).pluck(:route_id)
      @total     = RouteBranch.where(branch_id: @branch.id, route_id: @route_ids).sum('quantity * price')
      @paid      = Transaction.where('branch_id = ? AND extract(month from transaction_date) = ?', @branch.id, params[:date].to_date.month).sum(:amount) || 0
      render :payment
    end
  end
  
  
  private
  def params_transaction
    params.require(:transaction).permit(:billing_id, :transaction_date, :amount, :balance)
  end
end
