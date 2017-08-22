class FoodTypesController < ApplicationController
  load_and_authorize_resource
  
  before_action :set_food_type, only: [:show, :edit, :update, :destroy]
  
  def index
    @food_types = @food_types.where.not(is_deleted: true)
  end
  
  def new
    authorize :food_type
    @food_type = FoodType.new
  end
  
  def edit
    authorize :food_type
  end
  
  def create
    @food_type         = FoodType.new(food_type_params)
    @food_type.site_id = current_user.site_id
    respond_to do |format|
      if @food_type.save
        format.html { redirect_to food_types_path, notice: 'Food type was successfully created.' }
        format.json { render :show, status: :created, location: @food_type }
      else
        format.html { render :new }
        format.json { render json: @food_type.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def update
    respond_to do |format|
      if @food_type.update(food_type_params)
        format.html { redirect_to food_types_path, notice: 'Food type was successfully updated.' }
        format.json { render :show, status: :ok, location: @food_type }
      else
        format.html { render :edit }
        format.json { render json: @food_type.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def destroy
    authorize :food_type
    if @food_type.is_deleted
      @food_type.is_deleted = false
      notice                = 'Food type was successfully undo.'
    else
      @food_type.is_deleted = true
      notice                = 'Food type was successfully destroyed.'
    end
    @food_type.save!
    respond_to do |format|
      format.html { redirect_to food_types_url, notice: notice }
      format.json { head :no_content }
    end
  end
  
  private
  def set_food_type
    @food_type = FoodType.find(params[:id])
  end
  
  def food_type_params
    params.require(:food_type).permit(:name)
  end
end
