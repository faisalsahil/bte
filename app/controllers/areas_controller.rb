class AreasController < ApplicationController
  before_action :set_area, only: [:show, :edit, :update, :destroy]

  def index
    @areas = Area.all
  end
  

  def new
    @area = Area.new
  end

  def edit
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
    @area.destroy
    respond_to do |format|
      format.html { redirect_to areas_url, notice: 'Area was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
  
  def get_area_branches
    # # @area = Area.find_by_id(params[:id])
    # @branches = Branch.where(area_id: params[:area_id])
    # respond_to do |format|
    #   format.html {  }
    #   format.json { return render json: {status: true, branches: @branches} }
    # end


    @areas = Area.where(id: params[:area_id]).includes(:branches)
    respond_to do |format|
      format.html {  }
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
