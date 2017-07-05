class CompaniesController < ApplicationController
  before_action :set_company, only: [:show, :edit, :update, :destroy]
  before_action :set_sale_representative, only:[:new, :create]

  def index
    authorize :company
    @companies = Company.all
  end

  def new
    authorize :company
    @company = Company.new
    @statuses = [AppConstants::VISIT, AppConstants::LEAD, AppConstants::CONTRACTED]
    
  end

  def edit
    authorize :company
  end

  def create
    company_params = params[:company][:save_branch_as_nested].present? ? company_with_branch_params : only_company_params
    @company = Company.new(company_params)
    respond_to do |format|
      if @company.save
        # @company.update_status_and_code
        if params[:company][:save_branch_as_nested].present?
          @company.branches.first.update_status_and_code
        end
        format.html { redirect_to companies_path }
        format.json { render :show, status: :created, location: @company }
      else
        @statuses = [AppConstants::VISIT, AppConstants::LEAD, AppConstants::CONTRACTED]
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
      notice = 'Company was successfully undo.'
    else
      @company.is_deleted = true
      notice = 'Company was successfully destroyed.'
    end
    @company.save!
    respond_to do |format|
      format.html { redirect_to companies_url, notice:  notice}
      format.json { head :no_content }
    end
  end

  private
    def set_company
      @company = Company.find(params[:id])
    end
  
    def set_sale_representative
      role = Role.find_by_name(AppConstants::SALER)
      @sale_representatives = User.where(role_id: role.id)
    end

    def company_with_branch_params
      params.require(:company).permit(:company_name, :contact_name, :contact_email, :contact_phone, :company_status, :number_of_outlets, :save_branch_as_nested, branches_attributes: [:company_id, :branch_name, :branch_code, :area_id, :contact_name, :rate_per_kg, :contact_email, :contact_phone, :number_of_outlets, :food_type_id, :monthly_oil_used, :storage_type_id, :city_id, :street, :state_id, :zip, :latitude, :longitude, :branch_status, :representative])
    end

    def only_company_params
      params.require(:company).permit(:company_name, :contact_name, :contact_email, :contact_phone, :company_status, :number_of_outlets)
    end
end
