class RoutePolicy
  attr_reader :current_user, :record
  
  def initialize(current_user, record)
    @current_user = current_user
    @storage_type = record
  end
  
  def index?
    AppConstants::ROUTES_ARRAY.include? @current_user.role.name
  end

  def show?
    AppConstants::ROUTES_ARRAY.include? @current_user.role.name
  end
  
  def new?
    AppConstants::ROUTES_ARRAY.include? @current_user.role.name
  end

  def edit?
    AppConstants::ROUTES_ARRAY.include? @current_user.role.name
  end
  
  def destroy?
    AppConstants::ROUTES_ARRAY.include? @current_user.role.name
  end
end