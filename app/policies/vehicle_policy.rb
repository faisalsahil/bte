class VehiclePolicy
  attr_reader :current_user, :record
  
  def initialize(current_user, record)
    @current_user = current_user
    @storage_type = record
  end
  
  def index?
    AppConstants::VEHICLE_ARRAY.include? @current_user.role.name
  end
  
  def new?
    AppConstants::VEHICLE_ARRAY.include? @current_user.role.name
  end

  def edit?
    AppConstants::VEHICLE_ARRAY.include? @current_user.role.name
  end
  
  def destroy?
    AppConstants::VEHICLE_ARRAY.include? @current_user.role.name
  end
end