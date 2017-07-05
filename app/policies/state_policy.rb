class StatePolicy
  attr_reader :current_user, :record
  
  def initialize(current_user, record)
    @current_user = current_user
    @storage_type = record
  end
  
  def index?
    AppConstants::STATE_ARRAY.include? @current_user.role.name
  end

  def show?
    AppConstants::STATE_ARRAY.include? @current_user.role.name
  end
  
  def new?
    AppConstants::STATE_ARRAY.include? @current_user.role.name
  end

  def edit?
    AppConstants::STATE_ARRAY.include? @current_user.role.name
  end
  
  def destroy?
    AppConstants::STATE_ARRAY.include? @current_user.role.name
  end
end