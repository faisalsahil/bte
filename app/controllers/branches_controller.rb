class BranchesController < ApplicationController
  before_action :set_branch, only: [:show, :edit, :update, :destroy]

  def index
    if params[:type].present?
      if params[:type] == 'visit'
        @branches = Branch.where(branch_status: 'visit')
      elsif params[:type] == 'lead'
        @branches = Branch.where(branch_status: 'lead')
      elsif params[:type] == 'contract'
        @branches = Branch.where(branch_status: 'contract')
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
    @statuses = ['visit', 'lead', 'contract']
  end

  def edit
    if @branch.branch_status == 'visit'
      @statuses = ['visit', 'lead', 'contract']
    elsif @branch.branch_status == 'lead'
      @statuses = ['lead', 'contract']
    elsif @branch.branch_status == 'contract'
      @statuses = ['contract']
    end
    
    
    
    
  end

  def create
    @branch = Branch.new(branch_params)

    respond_to do |format|
      if @branch.save
        format.html { redirect_to @branch, notice: 'Branch was successfully created.' }
        format.json { render :show, status: :created, location: @branch }
      else
        @statuses = ['visit', 'lead', 'contract']
        format.html { render :new }
        format.json { render json: @branch.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @branch.update(branch_params)
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
      params.require(:branch).permit(:company_id, :branch_name, :branch_code, :area_id, :contact_name, :rate_per_kg, :contact_email, :contact_phone, :number_of_outlets, :food_type_id, :monthly_oil_used, :storage_type_id, :city_id, :street, :state_id, :zip, :latitude, :longitude, :branch_status)
    end
end
