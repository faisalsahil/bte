class CityPolicy
  attr_reader :current_user, :record
  
  def initialize(current_user, record)
    @current_user = current_user
    @storage_type = record
  end
  
  def index?
    AppConstants::CITY_ARRAY.include? @current_user.role.name
  end

  def show?
    AppConstants::CITY_ARRAY.include? @current_user.role.name
  end
  
  def new?
    AppConstants::CITY_ARRAY.include? @current_user.role.name
  end

  def edit?
    AppConstants::CITY_ARRAY.include? @current_user.role.name
  end
  
  def destroy?
    AppConstants::CITY_ARRAY.include? @current_user.role.name
  end
end