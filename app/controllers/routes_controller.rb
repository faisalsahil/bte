class RoutesController < ApplicationController
  load_and_authorize_resource
  before_action :set_route, only: [:show, :edit, :update, :destroy, :manage_branches]
  
  def index
    if params[:type].present?
      if params[:type] == AppConstants::ACTIVE
        @routes = @routes.where(is_completed: false, is_deleted: false).includes(:state, :city, :branches)
      elsif params[:type] == AppConstants::COMPLETED
        @routes = @routes.where(is_completed: true, is_deleted: false).includes(:state, :city, :branches)
      else
        @routes = @routes.where(is_deleted: false).includes(:state, :city, :branches)
      end
    else
      @routes = @routes.where(is_deleted: false).includes(:state, :city, :branches)
    end
  end
  
  def show
    authorize :route
  end
  
  def new
    @route  = Route.new
    @states = State.all
    @cities = City.all
  end
  
  def edit
    @branches       = @route.branches
    @areas          = @route.city.areas.where(state_id: @route.state_id)
    @states         = State.all
    @cities         = City.all
    @branch_ids     = @branches.pluck(:id)
    @route_area_ids = Branch.where(id: @branch_ids).pluck(:area_id).uniq
    @route_areas    = Area.where(id: @route_area_ids).includes(:branches)
  end
  
  def create
    @route         = Route.new(route_params)
    @route.areas   = params[:route][:areas]
    @route.site_id = current_user.site_id
    respond_to do |format|
      if @route.save
        branches = Branch.where(id: params[:route][:branches])
        branches&.each_with_index do |branch, index|
          route_branch       = @route.route_branches.build(branch_id: branch.id, position: index + 1)
          route_branch.price = branch.rate_per_kg
          route_branch.save!
        end
        
        format.html { redirect_to routes_path({ type: 'active' }), notice: 'Route was successfully created.' }
        format.json { render :show, status: :created, location: @route }
      else
        format.html { render :new }
        format.json { render json: @route.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def update
    respond_to do |format|
      if @route.update(route_params)
        branch_ids     = params[:route][:branches]
        route_branches = @route.route_branches
        if branch_ids.present?
          #  update from routes page
          branch_ids&.each do |branch_id|
            route_branch = route_branches.where(branch_id: branch_id).try(:first)
            if route_branch.blank?
              route_branch = @route.route_branches.build(branch_id: branch_id)
              route_branch.save!
            end
          end
          # delete existing branches
          @route.route_branches.where.not(branch_id: branch_ids).destroy_all
          
          # update positions
          update_branch_positions(@route)
        else
          #  update from assignment index page (complex form)
          mark_route_for_factory(@route)
        end
        if not branch_ids.present?
          format.html { redirect_to assignments_path({ type: 'active' }), notice: 'Successfully updated.' }
        else
          format.html { redirect_to routes_path({ type: 'active' }), notice: 'Successfully updated.' }
        end
        format.json { render :show, status: :ok, location: @route }
      else
        format.html { render :edit }
        format.json { render json: @route.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def destroy
    authorize :route
    @route
    if @route.is_deleted
      @route.is_deleted = false
      notice            = 'Route was successfully undo.'
    else
      @route.is_deleted = true
      notice            = 'Route was successfully destroyed.'
    end
    @route.save!
    respond_to do |format|
      format.html { redirect_to routes_url, notice: notice }
      format.json { head :no_content }
    end
  end
  
  def manage_branches
    @route_branches = @route.route_branches.order('position ASC')
  end
  
  def update_branch_positions(route)
    route_branches = route.route_branches.order('position ASC')
    route_branches&.each_with_index do |route_branch, index|
      route_branch.position = index + 1
      route_branch.save(validate: false)
    end
  end
  
  def mark_route_for_factory(route)
    route_branches = Route.find_by_id(route.id).route_branches
    route_branches.update_all(collected_date: Date.today)
    assignment          = Assignment.find_by_route_id(route.id)
    
    # Assign branch to other route
    transferred_objects = route_branches.where.not(transfer_to: nil)
    transferred_objects&.each do |object|
      route_transfer_to = Route.find_by_id(object.transfer_to).route_branches.order('position ASC')
      if route_transfer_to.present?
        position = route_transfer_to.last.position.to_i + 1
      else
        position = 1
      end
      route_branch_object = RouteBranch.find_by_route_id_and_branch_id(object.transfer_to, object.branch_id) || RouteBranch.new(route_id: object.transfer_to, branch_id: object.branch_id, price: object.price, position: position)
      route_branch_object.save! if route_branch_object.new_record?
    end
    
    if !route_branches.where(quantity: nil, transfer_to: nil, is_deleted: false).present?
      assignment.assignment_status = AppConstants::FACTORY
      assignment.save!
    end
  end
  
  def get_route_branches
    @route_branches = RouteBranch.where(route_id: params[:id]).includes(:branch)
    respond_to do |format|
      format.html {}
      format.js { render layout: false }
    end
  end
  
  def add_collection
    route              = Route.new(route_params)
    route.site_id      = @current_user_site.id
    route.is_completed = true
    route.save(validate: false)
    
    # add branch price
    route.route_branches.each do |route_branch|
      route_branch.price          = route_branch.try(:branch).try(:rate_per_kg)
      route_branch.collected_date = Date.today
      route_branch.save(validate: false)
    end
    route.route_branches.where(branch_id: nil).destroy_all
    
    # Save Assignment
    assignment                   = Assignment.new
    assignment.assigned_at       = Date.today
    assignment.route_id          = route.id
    assignment.is_completed      = true
    assignment.assignment_status = AppConstants::COMPLETED
    assignment.site_id           = @current_user_site.id
    
    driver_role           = Role.find_by_name(AppConstants::DRIVER)
    helper_role           = Role.find_by_name(AppConstants::HELPER)
    vehicle               = Vehicle.find_by_site_id(@current_user_site.id)
    
    # assignment.driver_id  = User.where(role_id: driver_role.id, site_id: @current_user_site.id).first.id
    # assignment.helper_id  = User.where(role_id: helper_role.id, site_id: @current_user_site.id).first.id
    assignment.vehicle_id = vehicle.id
    assignment.save!
    
    flash[:notice] = 'Collection submitted.'
    redirect_to new_factory_collection_path
  end
  
  private
  def set_route
    @route = Route.find(params[:id])
  end
  
  def route_params
    params.require(:route).permit(:state_id, :city_id, :areas, route_branches_attributes: [:id, :branch_id, :quantity, :is_transferred, :transfer_to, :is_deleted, :image, :price, :factory_image, :comment])
  end
end
