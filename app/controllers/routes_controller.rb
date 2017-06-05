class RoutesController < ApplicationController
  before_action :set_route, only: [:show, :edit, :update, :destroy, :manage_branches]

  def index
    if params[:type].present?
      if params[:type] == AppConstants::ACTIVE
        @routes = Route.where(is_completed: false).includes(:state,:city, :branches)
      elsif params[:type] == AppConstants::COMPLETED
        @routes = Route.where(is_completed: true).includes(:state,:city, :branches)
      else
        @routes = Route.all.includes(:state,:city, :branches)
      end
    else
      @routes = Route.all.includes(:state,:city, :branches)
    end
  end

  def show
  end

  def new
    @route = Route.new
  end

  def edit
    @branches   = @route.branches
    @areas      = @route.city.areas
    @branch_ids = @branches.pluck(:id)
    @route_area_ids      = Branch.where(id: @branch_ids).pluck(:area_id).uniq
    @route_areas = Area.where(id: @route_area_ids).includes(:branches)
  end

  def create
    @route = Route.new(route_params)
    respond_to do |format|
      if @route.save
        branches =  Branch.where(id: params[:route][:branches])
        branches&.each_with_index do |branch, index|
          route_branch = @route.route_branches.build(branch_id: branch.id, position: index + 1)
          route_branch.price = branch.rate_per_kg
          route_branch.save!
        end

        format.html { redirect_to routes_path, notice: 'Route was successfully created.' }
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
        branch_ids =  params[:route][:branches]
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
        if @route.is_completed
          format.html { redirect_to assignments_path({type: 'active'}), notice: 'Successfully updated.' }
        else
          format.html { redirect_to routes_path, notice: 'Successfully updated.' }
        end
        format.json { render :show, status: :ok, location: @route }
      else
        format.html { render :edit }
        format.json { render json: @route.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @route.destroy
    respond_to do |format|
      format.html { redirect_to routes_url, notice: 'Route was successfully destroyed.' }
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
      route_branch.save!
    end
  end
  
  def mark_route_for_factory(route)
    route_branches = Route.find_by_id(route.id).route_branches
    assignment     = Assignment.find_by_route_id(route.id)
 
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
    # if route_branches.where(quantity: nil, transfer_to: nil, is_deleted: false).present?
    #   route.is_completed = false
    #   route.save!
    # else
    #   assignment.assignment_status = AppConstants::FACTORY
    #   assignment.save!
    #   route.is_completed = true
    #   route.save!
    # end
  end
  
  def get_route_branches
    @route_branches = RouteBranch.where(route_id: params[:id]).includes(:branch)
    respond_to do |format|
      format.html {  }
      format.js { render layout: false }
    end
  end
  
  private
    def set_route
      @route = Route.find(params[:id])
    end

    def route_params
      params.require(:route).permit(:state_id, :city_id, :area_ids, route_branches_attributes: [:id, :quantity, :is_transferred, :transfer_to, :is_deleted, :image, :price, :factory_image])
    end
end
