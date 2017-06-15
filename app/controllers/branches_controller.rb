class BranchesController < ApplicationController
  before_action :set_branch, only: [:show, :edit, :update, :destroy]

  def index
    if params[:type].present?
      @branches = Branch.where(branch_status: params[:type]).includes(:company)
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
        @branch.update_status_and_code
        format.html { redirect_to branches_path({type: AppConstants::CONTRACTED}), notice: 'Branch was successfully created.' }
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
        @branch.update_status_and_code
        format.html { redirect_to branches_path({type: AppConstants::CONTRACTED}), notice: 'Branch was successfully updated.' }
        format.json { render :show, status: :ok, location: @branch }
      else
        role = Role.find_by_name(AppConstants::SALER)
        @sale_representatives = User.where(role_id: role.id)
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
    @branch = Branch.find_by_id(params[:id])
    @branch.branch_status = params[:status]
    @branch.save(validate: false)
    @branch.update_status_and_code
    return render json: true
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
      params.require(:branch).permit(:company_id, :branch_name, :branch_code, :area_id, :contact_name, :rate_per_kg, :contact_email, :contact_phone, :number_of_outlets, :food_type_id, :monthly_oil_used, :storage_type_id, :city_id, :street, :state_id, :zip, :latitude, :longitude, :branch_status, :representative, :visits_per_month)
    end
end
