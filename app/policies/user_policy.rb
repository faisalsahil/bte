class UserPolicy
  attr_reader :current_user, :record
  
  def initialize(current_user, record)
    @current_user = current_user
    @storage_type = record
  end
  
  def index?
    AppConstants::USER_ARRAY.include? @current_user.role.name
  end
  
  def new?
    AppConstants::USER_ARRAY.include? @current_user.role.name
  end

  def add_user?
    AppConstants::USER_ARRAY.include? @current_user.role.name
  end
  
  def block_unblock_user?
    AppConstants::USER_ARRAY.include? @current_user.role.name
  end
end