class BillingsController < ApplicationController
  before_action :set_billing, only: [:show, :edit, :update, :destroy]

  def index
    @billings = Billing.all.includes(:branch)
  end

  def show
    # @collections  = Collection.where(branch_id: @billing.branch_id).includes(:branch)
    @transactions = @billing.transactions
  end
  
  def create
    @billing = Billing.new(billing_params)

    respond_to do |format|
      if @billing.save
        format.html { redirect_to @billing, notice: 'Billing was successfully created.' }
        format.json { render :show, status: :created, location: @billing }
      else
        format.html { render :new }
        format.json { render json: @billing.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def destroy
    @billing.destroy
    respond_to do |format|
      format.html { redirect_to billings_url, notice: 'Billing was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def set_billing
      @billing = Billing.find(params[:id])
    end

    def billing_params
      params.require(:billing).permit(:branch_id, :total, :paid, :balance)
    end
end
