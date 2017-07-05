class AssignmentPolicy
  attr_reader :current_user, :record
  
  def initialize(current_user, record)
    @current_user = current_user
    @storage_type = record
  end
  
  def index?
    AppConstants::ASSIGNMENT_ARRAY.include? @current_user.role.name
  end

  def show?
    AppConstants::ASSIGNMENT_ARRAY.include? @current_user.role.name
  end
  
  def new?
    AppConstants::ASSIGNMENT_ARRAY.include? @current_user.role.name
  end

  def edit?
    AppConstants::ASSIGNMENT_ARRAY.include? @current_user.role.name
  end
  
  def destroy?
    AppConstants::ASSIGNMENT_ARRAY.include? @current_user.role.name
  end

  def factory_assignments?
    AppConstants::FACTORY_ASSIGNMENT_ARRAY.include? @current_user.role.name
  end

  def complete_assignment?
    AppConstants::ASSIGNMENT_ARRAY.include? @current_user.role.name
  end
end