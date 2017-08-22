class StatesController < ApplicationController
  load_and_authorize_resource
  before_action :set_state, only: [:show, :edit, :update, :destroy]
  
  def index
    @states = @states.includes(:cities)
  end
  
  def show
    authorize :state
  end
  
  def new
    authorize :state
    @state = State.new
  end
  
  def edit
    authorize :state
  end
  
  def create
    @state         = State.new(state_params)
    @state.site_id = current_user.site_id
    respond_to do |format|
      if @state.save
        format.html { redirect_to @state, notice: 'State was successfully created.' }
        format.json { render :show, status: :created, location: @state }
      else
        format.html { render :new }
        format.json { render json: @state.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def update
    respond_to do |format|
      if @state.update(state_params)
        format.html { redirect_to @state, notice: 'State was successfully updated.' }
        format.json { render :show, status: :ok, location: @state }
      else
        format.html { render :edit }
        format.json { render json: @state.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def destroy
    authorize :state
    if @state.is_deleted
      @state.is_deleted = false
      notice            = 'State was successfully undo.'
    else
      @state.is_deleted = true
      notice            = 'State was successfully destroyed.'
    end
    @state.save!
    respond_to do |format|
      format.html { redirect_to states_url, notice: notice }
      format.json { head :no_content }
    end
  end
  
  private
  def set_state
    @state = State.find(params[:id])
  end
  
  def state_params
    params.require(:state).permit(:name)
  end
end
