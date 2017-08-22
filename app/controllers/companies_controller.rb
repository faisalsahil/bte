class CompaniesController < ApplicationController
  load_and_authorize_resource :except => [:create]
  before_action :set_company, only: [:show, :edit, :update, :destroy]
  
  
  def index
    @companies = Company.where(site_id: @current_user_site.id, is_deleted: false)
    # @companies = @companies.where.not(is_deleted: true)
  end
  
  def new
    authorize :company
    @company = Company.new
    
    @statuses             = [AppConstants::VISIT, AppConstants::LEAD, AppConstants::CONTRACTED]
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
    authorize :company
  end
  
  def create
    company_params = params[:company][:save_branch_as_nested].present? ? company_with_branch_params : only_company_params
    
    if params[:company][:branches_attributes]["0"][:area_id].blank? && params[:company][:branches_attributes]["0"][:area_name].present?
      area          = Area.find_by_name_and_site_id(params[:company][:branches_attributes]["0"][:area_name], @current_user_site.id) || Area.new(site_id: @current_user_site.id)
      area.state_id = params[:company][:branches_attributes]["0"][:state_id]
      area.city_id  = params[:company][:branches_attributes]["0"][:city_id]
      area.name     = params[:company][:branches_attributes]["0"][:area_name]
      area.save if area.new_record?
      # params[:company][:branches_attributes]["0"][:area_id] = area.id
      binding.pry
      @company                = Company.new(company_params)
      @company.branches.first.area_id = area.id
    else
      @company                = Company.new(company_params)
    end
    
    @company.site_id = current_user.site_id
    binding.pry
    respond_to do |format|
      if @company.save
        if params[:company][:save_branch_as_nested].present?
          @company.branches.first.update_status_and_code
        end
        format.html { redirect_to companies_path }
        format.json { render :show, status: :created, location: @company }
      else
        @statuses             = [AppConstants::VISIT, AppConstants::LEAD, AppConstants::CONTRACTED]
        role                  = Role.find_by_name(AppConstants::SALER)
        @sale_representatives = User.where(site_id: @current_user_site.id, role_id: role.id, is_deleted: false)
        @companies            = Company.where(site_id: @current_user_site.id, is_deleted: false)
        @food_types           = FoodType.where(site_id: @current_user_site.id, is_deleted: false)
        @storage_types        = StorageType.where(site_id: @current_user_site.id, is_deleted: false)
        @states               = State.where(is_deleted: false)
        @cities               = City.where(is_deleted: false)
        @areas                = Area.where(site_id: @current_user_site.id)
        format.html { render :new }
        format.json { render json: @company.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def update
    respond_to do |format|
      if @company.update(only_company_params)
        format.html { redirect_to companies_path }
        format.json { render :show, status: :ok, location: @company }
      else
        format.html { render :edit }
        format.json { render json: @company.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def destroy
    authorize :company
    if @company.is_deleted
      @company.is_deleted = false
      notice              = 'Company was successfully undo.'
    else
      @company.is_deleted = true
      notice              = 'Company was successfully destroyed.'
    end
    @company.save!
    respond_to do |format|
      format.html { redirect_to companies_url, notice: notice }
      format.json { head :no_content }
    end
  end
  
  private
  def set_company
    @company = Company.find(params[:id])
  end
  
  def company_with_branch_params
    params.require(:company).permit(:company_name, :contract_type, :contact_name, :contact_email, :contact_phone, :company_status, :number_of_outlets, :save_branch_as_nested, branches_attributes: [:company_id, :branch_name, :branch_code, :area_id, :contact_name, :rate_per_kg, :contact_email, :contact_phone, :number_of_outlets, :food_type_id, :monthly_oil_used, :storage_type_id, :city_id, :street, :state_id, :zip, :latitude, :longitude, :branch_status, :representative, :area_name, :visits_per_month])
  end
  
  def only_company_params
    params.require(:company).permit(:company_name, :contact_name, :contact_email, :contact_phone, :company_status, :number_of_outlets)
  end
end
