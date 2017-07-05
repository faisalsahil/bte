class FactoryCollectionPolicy
  attr_reader :current_user, :record
  
  def initialize(current_user, record)
    @current_user = current_user
    @storage_type = record
  end
  
  def index?
    AppConstants::FACTORY_ARRAY.include? @current_user.role.name
  end

  def show?
    AppConstants::FACTORY_ARRAY.include? @current_user.role.name
  end
end