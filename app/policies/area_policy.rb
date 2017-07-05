class AreaPolicy
  attr_reader :current_user, :record
  
  def initialize(current_user, record)
    @current_user = current_user
    @storage_type = record
  end
  
  def index?
    AppConstants::AREA_ARRAY.include? @current_user.role.name
  end

  def show?
    AppConstants::AREA_ARRAY.include? @current_user.role.name
  end
  
  def new?
    AppConstants::AREA_ARRAY.include? @current_user.role.name
  end

  def edit?
    AppConstants::AREA_ARRAY.include? @current_user.role.name
  end
  
  def destroy?
    AppConstants::AREA_ARRAY.include? @current_user.role.name
  end
end