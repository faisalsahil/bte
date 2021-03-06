class AssignmentsController < ApplicationController
  load_and_authorize_resource
  before_action :set_assignment, only: [:show, :edit, :update, :destroy]
  before_action :set_data, only: [:new, :edit, :update, :create]
  
  def index
    @assignments = @assignments.where(assignment_status: params[:type])
  end
  
  def show
    authorize :assignment
    @route_branches = @assignment.route.route_branches.includes(:branch)
  end
  
  def new
    @assignment = Assignment.new
  end
  
  def edit
    authorize :assignment
  end
  
  def create
    @assignment         = Assignment.new(assignment_params)
    @assignment.site_id = current_user.site_id
    if @assignment.save
      redirect_to assignments_path({ type: AppConstants::ACTIVE }), notice: 'Assignment was successfully created.'
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
    authorize :assignment
    @assignment.route.route_branches.destroy_all
    @assignment.route.destroy
    @assignment.destroy
    respond_to do |format|
      format.html { redirect_to assignments_url, notice: 'Assignment was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
  
  def pdf_assignment
    @assignment     = Assignment.find_by_id(params[:id])
    @route_branches = @assignment.route.route_branches.where('is_deleted = false AND  transfer_to IS NULL')
    @branches       = Branch.sort_branches(@route_branches.pluck(:branch_id))
    respond_to do |format|
      format.pdf do
        pdf_name = "Route- #{@assignment.route_id} | #{@assignment.vehicle.vehicle_number}"
        render pdf:            pdf_name,
               disposition:    'attachment',
               # template: templ,
               layout:         'pdf.html', # use 'pdf.html' for a pdf.html.erb file
               page_offset:    0,
               book:           false,
               default_header: true,
               lowquality:     false,
               # save_only:       true,
               margin:         { bottom: 10, top: 15 },
               header:         {
                   html:      {
                       template: '/shared/header.pdf.erb', # use :template OR :url
                       layout:   'pdf.html' # optional, use 'pdf_plain.html' for a pdf_plain.html.erb file, defaults to main layout
                   },
                   font_name: 'Times New Roman',
                   font_size: 8,
                   margin:    { left: 0 },
                   line:      false
               }, # optionally you can pass plain html already rendered (useful if using pdf_from_string)
               footer:         {
                   html:      {
                       template: '/shared/footer.pdf.erb', # use :template OR :url
                       layout:   'pdf.html' # optional, use 'pdf_plain.html' for a pdf_plain.html.erb file, defaults to main layout
                   },
                   font_name: 'Times New Roman',
                   font_size: 8,
                   line:      true
               }
      end
    end
  end
  
  def factory_assignments
    authorize :assignment
    @route_ids      = Assignment.where(assignment_status: AppConstants::FACTORY, site_id: @current_user_site.id).pluck(:route_id)
    @route_branches = RouteBranch.where(route_id: @route_ids, transfer_to: nil, is_deleted: false, is_factory: false).includes(:route, :branch).order('route_id asc')
    
    respond_to do |format|
      format.html {}
    end
  end
  
  def factory_assignment_submit
    factory_collection          = FactoryCollection.new
    factory_collection.quantity = params[:factory_collection][:quantity]
    factory_collection.date     = params[:factory_collection][:date] || Date.today
    factory_collection.save
    route_ids = []
    params[:factory_collection][:route_branches_attributes].values.each do |route_branch|
      if route_branch[:is_factory].present? && route_branch[:is_factory] == '1'
        route_branch["factory_collection_id"] = factory_collection.id
        rb                                    = RouteBranch.find_by_id(route_branch[:id])
        rb.update_attributes(route_branch)
        route_ids << rb.route_id
      end
    end
    # Mark Route as complete and assignment as completed
    route_ids = route_ids.uniq
    routes    = Route.where(id: route_ids).includes(:route_branches, :assignment)
    routes.each do |route|
      if route.route_branches.where('is_deleted = false AND transfer_to IS NULL AND is_factory = false').blank?
        #  Mark route completed
        route.is_completed = true
        route.save!
        assignment                   = route.assignment
        assignment.is_completed      = true
        assignment.assignment_status = AppConstants::COMPLETED
        assignment.save!
      end
    end
    
    flash[:notice] = 'Successfully updated.'
    redirect_to factory_assignments_assignments_path
  end
  
  def complete_assignment
    @assignment     = Assignment.find_by_id(params[:id])
    @route          = @assignment.route
    @routes         = Route.active_routes.where('id != ? AND site_id = ?', @route.id, current_user.site_id)
    @route_branches = @route.route_branches.includes(:branch)
  end
  
  private
  def set_assignment
    @assignment = Assignment.find(params[:id])
  end
  
  def set_data
    @drivers           = User.where(site_id: @current_user_site.id, role_id: Role.find_by_name(AppConstants::DRIVER).id, is_deleted: false)
    @helpers           = User.where(site_id: @current_user_site.id, role_id: Role.find_by_name(AppConstants::HELPER).id, is_deleted: false)
    @vehicles          = Vehicle.where(site_id: @current_user_site.id, is_deleted: false)
    assigned_route_ids = Assignment.where(site_id: @current_user_site.id, is_completed: false).pluck(:route_id)
    @active_routes     = Route.active_routes.where(site_id: @current_user_site.id).where.not(id: assigned_route_ids, is_deleted: true)
  end
  
  def assignment_params
    params.require(:assignment).permit(:assigned_at, :driver_id, :helper_id, :vehicle_id, :route_id)
  end
  
  def factory_params
    params.require(:factory_collection).permit(:date, :quantity, route_branches_attributes: [:id, :is_factory, :factory_image])
  end
end
