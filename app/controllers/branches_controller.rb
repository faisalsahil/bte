class BranchesController < ApplicationController
  before_action :set_branch, only: [:show, :edit, :update, :destroy]

  def index
    if params[:type].present?
      if params[:type] == AppConstants::VISIT
        @branches = Branch.where(branch_status: AppConstants::VISIT)
      elsif params[:type] == AppConstants::LEAD
        @branches = Branch.where(branch_status: AppConstants::LEAD)
      elsif params[:type] == AppConstants::CONTRACTED
        @branches = Branch.where(branch_status: AppConstants::CONTRACTED)
      else
        @branches = Branch.all
      end
    else
      @branches = Branch.all
    end
  end

  def show
  end

  def new
    @branch = Branch.new
    @statuses = [AppConstants::VISIT, AppConstants::LEAD, AppConstants::CONTRACTED]
    role = Role.find_by_name(AppConstants::SALER)
    @sale_representatives = User.where(role_id: role.id)
  end

  def edit
    role = Role.find_by_name(AppConstants::SALER)
    @sale_representatives = User.where(role_id: role.id)
    if @branch.branch_status == AppConstants::VISIT
      @statuses = [AppConstants::VISIT, AppConstants::LEAD, AppConstants::CONTRACTED]
    elsif @branch.branch_status == AppConstants::LEAD
      @statuses = [AppConstants::LEAD, AppConstants::CONTRACTED]
    elsif @branch.branch_status == AppConstants::CONTRACTED
      @statuses = [AppConstants::CONTRACTED]
    end
  end

  def create
    @branch = Branch.new(branch_params)

    respond_to do |format|
      if @branch.save
        # @branch.company.update_status_and_code
        format.html { redirect_to @branch, notice: 'Branch was successfully created.' }
        format.json { render :show, status: :created, location: @branch }
      else
        @statuses = [AppConstants::VISIT, AppConstants::LEAD, AppConstants::CONTRACTED]
        format.html { render :new }
        format.json { render json: @branch.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @branch.update(branch_params)
        # @branch.company.update_status_and_code
        format.html { redirect_to @branch, notice: 'Branch was successfully updated.' }
        format.json { render :show, status: :ok, location: @branch }
      else
        format.html { render :edit }
        format.json { render json: @branch.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
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
      params.require(:branch).permit(:company_id, :branch_name, :branch_code, :area_id, :contact_name, :rate_per_kg, :contact_email, :contact_phone, :number_of_outlets, :food_type_id, :monthly_oil_used, :storage_type_id, :city_id, :street, :state_id, :zip, :latitude, :longitude, :branch_status, :representative)
    end
end
