class FoodTypesController < ApplicationController
  before_action :set_food_type, only: [:show, :edit, :update, :destroy]

  def index
    @food_types = FoodType.all
  end

  def new
    @food_type = FoodType.new
  end

  def edit
  end

  def create
    @food_type = FoodType.new(food_type_params)

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
    @food_type.destroy
    respond_to do |format|
      format.html { redirect_to food_types_url, notice: 'Food type was successfully destroyed.' }
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
