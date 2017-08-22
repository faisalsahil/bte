class BillingPolicy
  attr_reader :current_user, :record
  
  def initialize(current_user, record)
    @current_user = current_user
    @storage_type = record
  end
  
  def index?
    AppConstants::BILLING_ARRAY.include? @current_user.role.name
  end

  def invoice?
    AppConstants::BILLING_ARRAY.include? @current_user.role.name
  end
  
  def invoice_all?
    AppConstants::BILLING_ARRAY.include? @current_user.role.name
  end
end