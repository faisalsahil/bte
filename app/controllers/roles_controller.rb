class RolesController < ApplicationController
  before_action :set_role, only: [:show, :edit, :update, :destroy]

  def index
    authorize :role
    @roles = Role.all
  end

  def new
    authorize :role
    @role = Role.new
  end

  def edit
    authorize :role
  end

  def create
    @role = Role.new(role_params)

    respond_to do |format|
      if @role.save
        format.html { redirect_to roles_path, notice: 'Role was successfully created.' }
        format.json { render :show, status: :created, location: @role }
      else
        format.html { render :new }
        format.json { render json: @role.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @role.update(role_params)
        format.html { redirect_to roles_path, notice: 'Role was successfully updated.' }
        format.json { render :show, status: :ok, location: @role }
      else
        format.html { render :edit }
        format.json { render json: @role.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    authorize :role
    if @role.is_deleted
      @role.is_deleted = false
      notice = 'Role was successfully undo.'
    else
      @role.is_deleted = true
      notice = 'Role was successfully destroyed.'
    end
    @role.save(validate: false)
    respond_to do |format|
      format.html { redirect_to roles_url, notice: notice }
      format.json { head :no_content }
    end
  end

  private
    def set_role
      @role = Role.find(params[:id])
    end

    def role_params
      params.require(:role).permit(:name)
    end
end
