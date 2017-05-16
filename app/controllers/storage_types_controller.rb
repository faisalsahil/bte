class StorageTypesController < ApplicationController
  before_action :set_storage_type, only: [:show, :edit, :update, :destroy]

  def index
    @storage_types = StorageType.all
  end
  
  def new
    @storage_type = StorageType.new
  end

  def edit
  end

  def create
    @storage_type = StorageType.new(storage_type_params)

    respond_to do |format|
      if @storage_type.save
        format.html { redirect_to storage_types_path, notice: 'Storage type was successfully created.' }
        format.json { render :show, status: :created, location: @storage_type }
      else
        format.html { render :new }
        format.json { render json: @storage_type.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @storage_type.update(storage_type_params)
        format.html { redirect_to storage_types_path, notice: 'Storage type was successfully updated.' }
        format.json { render :show, status: :ok, location: @storage_type }
      else
        format.html { render :edit }
        format.json { render json: @storage_type.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @storage_type.destroy
    respond_to do |format|
      format.html { redirect_to storage_types_url, notice: 'Storage type was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def set_storage_type
      @storage_type = StorageType.find(params[:id])
    end

    def storage_type_params
      params.require(:storage_type).permit(:name)
    end
end