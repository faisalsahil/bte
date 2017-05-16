class TransactionsController < ApplicationController
  def payment
    @billing     = Billing.find_by_id(params[:billing_id])
    @transaction = @billing.transactions.build
  end
  
  def create_payment
    @billing = Billing.find_by_id(params[:billing_id])
    @transaction = @billing.transactions.build(params_transaction)
    if @billing && params[:transaction][:amount].to_f <= @billing.balance.to_f
      if @transaction.save
        total_paid      = @billing.paid  + @transaction.amount
        @billing.paid    = total_paid
        @billing.balance = @billing.total  - total_paid
        @billing.save!
      end
      redirect_to billings_path
    else
      flash[:danger] = 'amount should be less than the balance'
      render :payment
    end
  end
  
  
  private
  def params_transaction
    params.require(:transaction).permit(:billing_id, :transaction_date, :amount)
  end
end
