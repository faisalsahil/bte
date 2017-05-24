class AssignmentsController < ApplicationController
  before_action :set_assignment, only: [:show, :edit, :update, :destroy]
  before_action :set_data, only: [:new, :edit, :update, :create]
  
  def index
    if params[:type].present?
      if params[:type] == 'active'
        @assignments = Assignment.where(is_completed: false)
      elsif params[:type] == 'completed'
        @assignments = Assignment.where(is_completed: true)
      else
        @assignments = Assignment.all
      end
    else
      @assignments = Assignment.all
    end
  end

  def show
    @route_branches = @assignment.route.route_branches.includes(:branch)
  end

  def new
    @assignment = Assignment.new
  end

  def edit
    
  end

  def create
    @assignment = Assignment.new(assignment_params)
    if @assignment.save
      
      redirect_to assignments_path, notice: 'Assignment was successfully created.'
    else
      render :new
    end
    
  end

  def update
    respond_to do |format|
      if @assignment.update(assignment_params)
        format.html { redirect_to assignments_path, notice: 'Assignment was successfully updated.' }
        format.json { render :show, status: :ok, location: @assignment }
      else
       
        format.html { render :edit }
        format.json { render json: @assignment.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @assignment.destroy
    respond_to do |format|
      format.html { redirect_to assignments_url, notice: 'Assignment was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
  
  def pdf_assignment
    @assignment = Assignment.find_by_id(params[:id])
    @route_branches = @assignment.route.route_branches.includes(:branch)
    respond_to do |format|
      format.pdf do
        pdf_name = "Route- #{@assignment.route_id} | #{@assignment.vehicle.vehicle_number}"
        render pdf: pdf_name,
               disposition: 'attachment',
               # template: templ,
               layout: 'pdf.html', # use 'pdf.html' for a pdf.html.erb file
               page_offset: 0,
               book: false,
               default_header: true,
               lowquality: false,
               # save_only:       true,
               margin: {bottom: 25, top: 25},
               header: {
                   html: {
                       template: '/assignments/header.pdf.erb', # use :template OR :url
                       layout: 'pdf.html' # optional, use 'pdf_plain.html' for a pdf_plain.html.erb file, defaults to main layout
                   },
                   font_name: 'Times New Roman',
                   font_size: 14,
                   line: false
               }, # optionally you can pass plain html already rendered (useful if using pdf_from_string)
               footer: {
                   html: {
                       template: '/assignments/footer.pdf.erb', # use :template OR :url
                       layout: 'pdf.html' # optional, use 'pdf_plain.html' for a pdf_plain.html.erb file, defaults to main layout
                   },
                   font_name: 'Times New Roman',
                   font_size: 14,
                   line: true
               }
      end
    end
  end

  def complete_assignment
    @assignment     = Assignment.find_by_id(params[:id])
    @route          = @assignment.route
    @routes         = Route.where.not(id: @route.id)
    @route_branches = @route.route_branches.includes(:branch)
  end

  private
    def set_assignment
      @assignment = Assignment.find(params[:id])
    end
  
    def set_data
      @drivers  = User.where(role_id: Role.find_by_name(AppConstants::DRIVER).id)
      @helpers  = User.where(role_id: Role.find_by_name(AppConstants::HELPER).id)
      @vehicles = Vehicle.all
      @active_routes = Route.all
    end

    def assignment_params
      params.require(:assignment).permit(:assigned_at, :driver_id, :helper_id, :vehicle_id, :route_id)
    end
end
