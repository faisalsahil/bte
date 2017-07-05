class FoodTypePolicy
  attr_reader :current_user, :record
  
  def initialize(current_user, record)
    @current_user = current_user
    @storage_type = record
  end
  
  def index?
    AppConstants::FOODTYPE_ARRAY.include? @current_user.role.name
  end
  
  def new?
    AppConstants::FOODTYPE_ARRAY.include? @current_user.role.name
  end

  def edit?
    AppConstants::FOODTYPE_ARRAY.include? @current_user.role.name
  end
  
  def destroy?
    AppConstants::FOODTYPE_ARRAY.include? @current_user.role.name
  end
end