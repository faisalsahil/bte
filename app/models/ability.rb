class Ability
  include CanCan::Ability
  
  def initialize(user)
    unless user.nil?
      role = user.role.name
      
      if role == AppConstants::SUPER_ADMIN
        super_admin user
      elsif role == AppConstants::ADMIN
        admin user
      elsif role == AppConstants::ACCOUNTANT
        accountant user
      elsif role == AppConstants::FACTORY
        factory user
      elsif role == AppConstants::PFA
        pfa user
      end
      
      all_users user
    end
  end
  
  def super_admin(user)
    can :manage, User
    can [:new, :add_user], User
    can :manage, Site
  end
  
  def admin(user)
    can :manage, User, {site_id: user.site_id}
    
    can [:index], Area, state: {site_id: user.site_id}
    can [:new, :create, :edit, :update, :destroy, :get_area_branches], Area
    
    can :manage, Assignment, {site_id: user.site_id}
    
    
    can :manage, Billing, {site_id: user.site_id}

    can [:index], Branch, company: {site_id: user.site_id}
    can [:new, :show, :create, :edit, :update, :destroy, :update_branch_status], Branch

    
    can [:get_state_cities, :get_city_areas], City
      
    can :manage, State, {site_id: user.site_id}
    can :manage, Company, {site_id: user.site_id}
    can :manage, FactoryCollection
    can :manage, FoodType, {site_id: user.site_id}
    can :manage, Note
    can :manage, :reports_controller
    
    
    can [:index], Route, {site_id: user.site_id}
    can [:new, :create, :edit, :update, :destroy, :manage_branches, :update_branch_positions, :get_route_branches, :add_collection], Route
    
    can :manage, RouteBranch
    can :manage, State, {site_id: user.site_id}
    can :manage, StorageType, {site_id: user.site_id}
    can :manage, Vehicle, {site_id: user.site_id}

    can [:index], ProductSale, {site_id: user.site_id}
    can [:new, :create, :edit, :update, :destroy], ProductSale
    can [:site_product_sale], Site
    
    can :manage, Transaction
  end

  def accountant(user)
    can :manage, Assignment, {site_id: user.site_id}
    can :manage, Branch
    can :manage, Note
    can :manage, Report
    can :manage, Route, {site_id: user.site_id}
    can :manage, RouteBranch
  end

  def factory(user)
    can :manage, FactoryCollection
  end
  
  def driver(user)
    
  end

  def helper(user)
  end

  def saler(user)
    can :manage, Area
    can :manage, Assignment
    can :manage, Billing
    can :manage, Branch
    can :manage, City
    can :manage, State
    can :manage, Company
  end
  
  def pfa(user)
    can :manage, User, {site_id: user.site_id}
    can :manage, Site
    
    
    # can [:indeex, :new, :show, :edit], Branch, user: { id: user.id }
    
      can [:index, :show], Branch
    
    can :manage, FactoryCollection
    can [:add_collection], Route
    can [:index], Area, state: {site_id: user.site_id}
    can [:new, :create, :edit, :update, :destroy, :get_area_branches], Area
    can :manage, :reports_controller
    can [:get_state_cities, :get_city_areas], City
    can [:index], ProductSale, {site_id: user.site_id}
    can [:new, :create, :edit, :update, :destroy], ProductSale
  end
  
  def all_users(user)
    can [:update], User, id: user.id
  end

end
