class RolePolicy
  attr_reader :current_user, :record
  
  def initialize(current_user, record)
    @current_user = current_user
    @storage_type = record
  end
  
  def index?
    AppConstants::ROLE_ARRAY.include? @current_user.role.name
  end

  def new?
    AppConstants::ROLE_ARRAY.include? @current_user.role.name
  end

  def edit?
    AppConstants::ROLE_ARRAY.include? @current_user.role.name
  end
  
  def destroy?
    AppConstants::ROLE_ARRAY.include? @current_user.role.name
  end
end