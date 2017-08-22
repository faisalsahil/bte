class AreasController < ApplicationController
  load_and_authorize_resource
  before_action :set_area, only: [:show, :edit, :update, :destroy]
  
  def index
    @areas = @areas.where.not(is_deleted: true)
  end
  
  def new
    @area   = Area.new
    @states = State.where(site_id: @current_user_site.id)
  end
  
  def edit
    authorize :area
    @cities = @area.state.cities
  end
  
  def create
    @area = Area.new(area_params)
    
    respond_to do |format|
      if @area.save
        format.html { redirect_to areas_path, notice: 'Area was successfully created.' }
        format.json { render :show, status: :created, location: @area }
      else
        @cities = @area.try(:state).try(:cities)
        format.html { render :new }
        format.json { render json: @area.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def update
    respond_to do |format|
      if @area.update(area_params)
        format.html { redirect_to areas_path, notice: 'Area was successfully updated.' }
        format.json { render :show, status: :ok, location: @area }
      else
        @cities = @area.state.cities
        format.html { render :edit }
        format.json { render json: @area.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def destroy
    authorize :area
    if @area.is_deleted
      @area.is_deleted = false
      notice           = 'Area was successfully undo.'
    else
      @area.is_deleted = true
      notice           = 'Area was successfully destroyed.'
    end
    @area.save!
    respond_to do |format|
      format.html { redirect_to areas_url, notice: notice }
      format.json { head :no_content }
    end
  end
  
  def get_area_branches
    @areas = Area.where(id: params[:area_id]).includes(:branches)
    respond_to do |format|
      format.html {}
      format.js { render layout: false }
    end
  end
  
  private
  def set_area
    @area = Area.find(params[:id])
  end
  
  def area_params
    params.require(:area).permit(:name, :state_id, :city_id)
  end
end
