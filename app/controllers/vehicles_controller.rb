class VehiclesController < ApplicationController
  before_action :set_vehicle, only: [:show, :edit, :update, :destroy]

  def index
    @vehicles = Vehicle.all
  end

  def new
    @vehicle = Vehicle.new
  end

  def edit
  end

  def create
    @vehicle = Vehicle.new(vehicle_params)

    respond_to do |format|
      if @vehicle.save
        format.html { redirect_to vehicles_path }
        format.json { render :show, status: :created, location: @vehicle }
      else
        format.html { render :new }
        format.json { render json: @vehicle.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @vehicle.update(vehicle_params)
        format.html { redirect_to vehicles_path }
        format.json { render :show, status: :ok, location: @vehicle }
      else
        format.html { render :edit }
        format.json { render json: @vehicle.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @vehicle.destroy
    respond_to do |format|
      format.html { redirect_to vehicles_url, notice: 'Vehicle was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
  
  def assignment
    @vehicles = Vehicle.all
    
  end
  
  def get_users
    user_vehicle = UserVehicle.where(end_date: nil, vehicle_id: params[:vehicle_id], is_deleted: false)
    role_id = Role.find_by_name(AppConstants::DRIVER).id
    @users = User.where(role_id: role_id)
    
    if user_vehicle.present?
      return render json: {status: false, users: @users}
    else
      return render json: {status: true, users: @users}
    end
    # return render json: false
  end
  
  def assign_vehicle
    existing_user_vehicle    = UserVehicle.where(end_date: nil, vehicle_id: params[:vehicle_id], is_deleted: false).try(:first)
    is_othr_vehicle_assigned = UserVehicle.where('end_date IS NULL AND vehicle_id != ? AND user_id = ? AND DATE(assigned_date) <= DATE(?)', params[:vehicle_id], params[:user_id], params[:start_date].to_date.strftime('%Y-%m-%d')).try(:first)
    if existing_user_vehicle.present?
      if existing_user_vehicle.assigned_date.strftime('%d/%m/%Y') == params[:start_date]
        existing_user_vehicle.user_id  = params[:user_id]
        is_exist = true
      elsif !is_othr_vehicle_assigned.present?
        existing_user_vehicle.end_date = params[:start_date]
        is_exist = false
      end
      existing_user_vehicle.save!
    end
    if !is_exist && !is_othr_vehicle_assigned.present?
      user_vehicle = UserVehicle.new(assigned_date: params[:start_date], vehicle_id: params[:vehicle_id], user_id: params[:user_id])
      user_vehicle.save!
    end
    redirect_to assignment_vehicles_path
  end
  
  # def unassigned_vehicle
  #   @user_vehicle = UserVehicle.find_by_id(params[:id])
  #   @user_vehicle.is_deleted = true
  #   @user_vehicle.save!
  #   respond_to do |format|
  #     format.html { redirect_to vehicles_url, notice: 'Vehicle was successfully destroyed.' }
  #     format.json { head :no_content }
  #   end
  # end
  
  def assign_branches
    @vehicles = Vehicle.all
  end
  
  def branches_assignment
    schedule = Schedule.find_by_scheduled_date(params[:start_date])
    if !schedule.present?
      schedule = Schedule.new(scheduled_at: params[:start_date])
      schedule.save!
    end

    params[:branches] && params[:branches].each do |branch_id|
      obj = schedule.schedule_branches.build(branch_id: branch_id, vehicle_id: params[:vehicle_id])
      obj.save
    end
    
    redirect_to assign_branches_vehicles_path
  end

  private
    def set_vehicle
      @vehicle = Vehicle.find(params[:id])
    end

    def vehicle_params
      params.require(:vehicle).permit(:vehicle_type, :vehicle_number)
    end
end
