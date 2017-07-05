class BranchPolicy
  attr_reader :current_user, :record
  
  def initialize(current_user, record)
    @current_user = current_user
    @storage_type = record
  end
  
  def index?
    AppConstants::BRANCH_ARRAY.include? @current_user.role.name
  end

  def show?
    AppConstants::BRANCH_ARRAY.include? @current_user.role.name
  end
  
  def new?
    AppConstants::BRANCH_ARRAY.include? @current_user.role.name
  end

  def edit?
    AppConstants::BRANCH_ARRAY.include? @current_user.role.name
  end
  
  def destroy?
    AppConstants::BRANCH_ARRAY.include? @current_user.role.name
  end
end