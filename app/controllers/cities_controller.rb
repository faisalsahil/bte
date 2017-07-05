class CitiesController < ApplicationController
  before_action :set_city, only: [:show, :edit, :update, :destroy]

  def index
    authorize :city
    @cities = City.all.includes(:state)
  end

  def show
    authorize :city
  end

  def new
    authorize :city
    @city = City.new
  end

  def edit
    authorize :city
  end

  def create
    @city = City.new(city_params)

    respond_to do |format|
      if @city.save
        format.html { redirect_to cities_path, notice: 'City was successfully created.' }
        format.json { render :show, status: :created, location: @city }
      else
        format.html { render :new }
        format.json { render json: @city.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @city.update(city_params)
        format.html { redirect_to cities_path, notice: 'City was successfully updated.' }
        format.json { render :show, status: :ok, location: @city }
      else
        format.html { render :edit }
        format.json { render json: @city.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    authorize :city
    if @city.is_deleted
      @city.is_deleted = false
      notice = 'City was successfully undo.'
    else
      @city.is_deleted = true
      notice = 'City was successfully destroyed.'
    end
    @city.save!
    respond_to do |format|
      format.html { redirect_to cities_url, notice: notice }
      format.json { head :no_content }
    end
  end
  
  def get_state_cities
    @state = State.find_by_id(params[:state_id])
    @cities = @state.cities.where(is_deleted: false)
    respond_to do |format|
      format.html {  }
      format.json { return render json: {status: true, cities: @cities} }
    end
  end
  
  def get_city_areas
    @city = City.find_by_id(params[:id])
    @areas = @city.areas.where(is_deleted: false)
    respond_to do |format|
      format.html {  }
      format.json { return render json: {status: true, areas: @areas} }
    end
  end

  private
    def set_city
      @city = City.find(params[:id])
    end

    def city_params
      params.require(:city).permit(:state_id, :name)
    end
end
