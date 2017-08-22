class BranchesController < ApplicationController
  load_and_authorize_resource
  before_action :set_branch, only: [:show, :edit, :update, :destroy]
  
  def index
    if params[:type].present?
      @type = params[:type]
      if @current_user_role == AppConstants::PFA
        company_ids = Company.where(site_id: @current_user_site.id).pluck(:id)
        @branches   = Branch.where(branch_status: params[:type], company_id: company_ids).includes(:company)
      else
        @branches = @branches.where(branch_status: params[:type]).includes(:company)
      end
      
      if params[:type] == AppConstants::VISIT
        @statuses = [AppConstants::VISIT, AppConstants::LEAD, AppConstants::CONTRACTED]
      elsif params[:type] == AppConstants::LEAD
        @statuses = [AppConstants::LEAD, AppConstants::CONTRACTED]
      elsif params[:type] == AppConstants::CONTRACTED
        @statuses = [AppConstants::CONTRACTED]
      else
        @branches = Branch.where(branch_status: AppConstants::CONTRACTED).includes(:company)
        @statuses = [AppConstants::CONTRACTED]
      end
    else
      @branches = Branch.where(branch_status: AppConstants::CONTRACTED).includes(:company)
      @statuses = [AppConstants::CONTRACTED]
    end
  end
  
  def show
    authorize :branch
  end
  
  def new
    @branch = Branch.new
    if not @current_user_site.is_automate_process
      @statuses = [AppConstants::CONTRACTED]
    else
      @statuses = [AppConstants::VISIT, AppConstants::LEAD, AppConstants::CONTRACTED]
    end
    
    
    role                  = Role.find_by_name(AppConstants::SALER)
    @sale_representatives = User.where(site_id: @current_user_site.id, role_id: role.id, is_deleted: false)
    @companies            = Company.where(site_id: @current_user_site.id, is_deleted: false)
    @food_types           = FoodType.where(site_id: @current_user_site.id, is_deleted: false)
    @storage_types        = StorageType.where(site_id: @current_user_site.id, is_deleted: false)
    @states               = State.where(is_deleted: false)
    @cities               = City.where(is_deleted: false)
    @areas                = Area.where(site_id: @current_user_site.id)
  end
  
  def edit
    role                  = Role.find_by_name(AppConstants::SALER)
    @companies            = Company.where(site_id: @current_user_site.id, is_deleted: false)
    @sale_representatives = User.where(site_id: @current_user_site.id, role_id: role.id, is_deleted: false)
    @food_types           = FoodType.where(site_id: @current_user_site.id, is_deleted: false)
    @storage_types        = StorageType.where(site_id: @current_user_site.id, is_deleted: false)
    @states               = State.where(is_deleted: false)
    @cities               = City.where(is_deleted: false)
    @areas                = Area.where(site_id: @current_user_site.id)
    
    if @branch.branch_status == AppConstants::VISIT
      @statuses = [AppConstants::VISIT, AppConstants::LEAD, AppConstants::CONTRACTED]
    elsif @branch.branch_status == AppConstants::LEAD
      @statuses = [AppConstants::LEAD, AppConstants::CONTRACTED]
    elsif @branch.branch_status == AppConstants::CONTRACTED
      @statuses = [AppConstants::CONTRACTED]
    end
  end
  
  def create
    if params[:branch][:area_id].blank? && params[:branch][:area_name].present?
      area          = Area.find_by_name(params[:branch][:area_name]) || Area.new(site_id: @current_user_site.id)
      area.state_id = params[:branch][:state_id]
      area.city_id  = params[:branch][:city_id]
      area.save! if area.new_record?
      params[:branch][:area_id] = area.id
    end
    @branch = Branch.new(branch_params)
    
    respond_to do |format|
      if @branch.save
        @branch.update_status_and_code
        format.html { redirect_to branches_path({ type: AppConstants::CONTRACTED }), notice: 'Branch was successfully created.' }
        format.json { render :show, status: :created, location: @branch }
      else
        if @current_user_site.is_automate_process
          @statuses = [AppConstants::CONTRACTED]
        else
          @statuses = [AppConstants::VISIT, AppConstants::LEAD, AppConstants::CONTRACTED]
        end
        role                  = Role.find_by_name(AppConstants::SALER)
        @sale_representatives = User.where(role_id: role.id)
        @companies            = Company.where(site_id: @current_user_site.id, is_deleted: false)
        @food_types           = FoodType.where(site_id: @current_user_site.id, is_deleted: false)
        @storage_types        = StorageType.where(site_id: @current_user_site.id, is_deleted: false)
        @states               = State.where(is_deleted: false)
        @cities               = City.where(is_deleted: false)
        @areas                = Area.where(site_id: @current_user_site.id)
        format.html { render :new }
        format.json { render json: @branch.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def update
    respond_to do |format|
      if @branch.update(branch_params)
        @branch.update_status_and_code
        format.html { redirect_to branches_path({ type: AppConstants::CONTRACTED }), notice: 'Branch was successfully updated.' }
        format.json { render :show, status: :ok, location: @branch }
      else
        role                  = Role.find_by_name(AppConstants::SALER)
        @companies            = Company.where(site_id: @current_user_site.id, is_deleted: false)
        @sale_representatives = User.where(site_id: @current_user_site.id, role_id: role.id, is_deleted: false)
        @food_types           = FoodType.where(site_id: @current_user_site.id, is_deleted: false)
        @storage_types        = StorageType.where(site_id: @current_user_site.id, is_deleted: false)
        @states               = State.where(is_deleted: false)
        @cities               = City.where(is_deleted: false)
        @areas                = Area.where(site_id: @current_user_site.id)
        
        if @branch.branch_status == AppConstants::VISIT
          @statuses = [AppConstants::VISIT, AppConstants::LEAD, AppConstants::CONTRACTED]
        elsif @branch.branch_status == AppConstants::LEAD
          @statuses = [AppConstants::LEAD, AppConstants::CONTRACTED]
        elsif @branch.branch_status == AppConstants::CONTRACTED
          @statuses = [AppConstants::CONTRACTED]
        end
        format.html { render :edit }
        format.json { render json: @branch.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def update_branch_status
    @branch               = Branch.find_by_id(params[:id])
    @branch.branch_status = params[:status]
    @branch.save(validate: false)
    @branch.update_status_and_code
    return render json: true
  end
  
  def destroy
    authorize :branch
    @branch.destroy
    respond_to do |format|
      format.html { redirect_to branches_url, notice: 'Branch was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
  
  private
  def set_branch
    @branch = Branch.find(params[:id])
  end
  
  def branch_params
    params.require(:branch).permit(:company_id, :branch_name, :contract_type, :branch_code, :area_id, :contact_name, :rate_per_kg, :contact_email, :contact_phone, :number_of_outlets, :food_type_id, :monthly_oil_used, :storage_type_id, :city_id, :street, :state_id, :zip, :latitude, :longitude, :branch_status, :representative, :visits_per_month, :area_name)
  end
end
