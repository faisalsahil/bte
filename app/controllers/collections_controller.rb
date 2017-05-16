class CollectionsController < ApplicationController
  
  def new
    @schedule_branch = ScheduleBranch.find_by_id(params[:schedule_branch_id])
    @collection = Collection.new
  end

  def create
    date = params[:date]
    qnty = params[:qnty].to_f
    @schedule_branch = ScheduleBranch.find_by_id(params[:schedule_branch_id])
    @collection = Collection.where('vehicle_id = ? AND DATE(collected_at) = DATE(?) AND branch_id = ?', @schedule_branch.vehicle_id, date.to_date.strftime('%Y-%m-%d'), @schedule_branch.branch_id).try(:first) || Collection.new
    # @collection = Collection.find_by_collected_at_and_vehicle_id_and_branch_id(date, @schedule_branch.vehicle_id, @schedule_branch.branch_id) || Collection.new
    existing_quantity = @collection.quantity if !@collection.new_record?
    @collection.branch_id    = @schedule_branch.branch_id
    @collection.vehicle_id   = @schedule_branch.vehicle_id
    @collection.collected_at = date
    @collection.quantity     = qnty
    if @collection.save
      billing = Billing.find_by_branch_id(@collection.branch_id) || Billing.new
      recent_collected_amount = qnty * @schedule_branch.branch.rate_per_kg
      if billing.new_record?
        billing.branch_id = @collection.branch_id
        billing.total     = recent_collected_amount
        billing.paid      = 0
        billing.balance   = recent_collected_amount
      else
        if existing_quantity.present?
          existing_qnty_amount = existing_quantity * @schedule_branch.branch.rate_per_kg
          billing.total     = billing.total   + recent_collected_amount - existing_qnty_amount
          billing.balance   = billing.balance + recent_collected_amount - existing_qnty_amount
        else
          billing.total     = billing.total + recent_collected_amount
          billing.balance   = billing.balance + recent_collected_amount
        end
      end
      billing.save!
      return render json: {status: true, qnty: qnty, message: 'Collection successfully submitted.'}
    else
      return render json: {status: false, qnty: qnty, message: 'Collection not submitted.'}
    end
  end
  
  def edit
    
  end
  
  def update
    
  end
  
  private
  
  def collection_params
    params.require(:collection).permit(:vehicle_id, :branch_id,  :collected_at, :quantity)
  end
end
