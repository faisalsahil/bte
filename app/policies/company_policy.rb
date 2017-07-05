class CompanyPolicy
  attr_reader :current_user, :record
  
  def initialize(current_user, record)
    @current_user = current_user
    @storage_type = record
  end
  
  def index?
    AppConstants::COMPANY_ARRAY.include? @current_user.role.name
  end
  
  def new?
    AppConstants::COMPANY_ARRAY.include? @current_user.role.name
  end

  def edit?
    AppConstants::COMPANY_ARRAY.include? @current_user.role.name
  end
  
  def destroy?
    AppConstants::COMPANY_ARRAY.include? @current_user.role.name
  end
end