class ReportsController < ApplicationController
  authorize_resource class: :reports_controller, parent: false
  
  def index
    @type = params[:type] || nil
  end
  
  def generate_report
    @from_date = params[:from_date].try(:to_date)
    @to_date   = params[:to_date].try(:to_date)
    @type      = params[:report_type]
    @month_year= params[:month_wise].try(:to_date) || Date.today.strftime("%m/%Y")
    @data      = params
    if @type == AppConstants::Lead_REPORT
      @branches = lead_report(params)
    end
    
    if @type == AppConstants::VISIT_REPORT
      @branches = visit_report(params)
    end
    
    if @type == AppConstants::CONTRACTED_REPORT
      @branches = contracted_report(params)
    end
    
    if @type == AppConstants::ACTIVE_ROUTES_REPORT
      @route_branches, @states, @cities, @areas = active_route_report(params)
    end
    
    if @type == AppConstants::NO_WASTE_OIL_REPORT
      @route_branches, @branches = no_waste_oil_report(params)
    end
    
    if @type == AppConstants::MONTH_WISE_COLLECTION_REPORT
      company_ids = Company.where(site_id: @current_user_site.id).pluck(:id)
      @branches   = Branch.joins(:company).where(branch_status: AppConstants::CONTRACTED, company_id: company_ids).includes(:route_branches, :area, :company, :city, :state).order('company_code ASC, branch_code ASC')
    end
    
    if @type == AppConstants::RESTAURANT_WISE_COLLECTION_REPORT
      company_ids = Company.where(site_id: @current_user_site.id).pluck(:id)
      @branches   = Branch.joins(:company).where(branch_status: AppConstants::CONTRACTED, company_id: company_ids).includes(:route_branches, :area, :company, :city, :state).order('company_code ASC, branch_code ASC')
    end
    
    if @type == AppConstants::NOT_VISITED_REPORT
      @route_branches = not_visited_report(params)
    end
    
    if @type == AppConstants::FACTORY_COLLECTION_REPORT
      @factory_collections = factory_collection(params)
      @route_branches      = RouteBranch.where(factory_collection_id: @factory_collections.pluck(:id)).order('factory_collection_id ASC').includes(:branch, :factory_collection, :route)
    end
    
    if @type == AppConstants::URGENT_ACTION_REPORT
      @notes = Note.where(site_id: @current_user_site.id).order('created_at DESC').includes('branch')
      
      if params[:from_date].present?
        @notes = @notes.where('DATE(created_at) >= DATE(?)', params[:from_date].to_date)
      end
      
      if params[:to_date].present?
        @notes = @notes.where('DATE(created_at) <= DATE(?)', params[:to_date].to_date)
      end
    end
    
    if @type == AppConstants::PROFILING_OF_LEADS_REPORT
      @branches      = profiling_of_leads_report(params)
      @contract_type = params[:contract_type]
    end
    
    if @type == AppConstants::PROOF_OF_SALE_REPORT
      @product_sales = proof_sale_report(params)
    end
    
    if @type == AppConstants::TRUCK_REPORT
      @truck_report_data = truck_report(params)
    end
    
    
    respond_to do |format|
      format.html { redirect_to reports_path }
      format.js { render layout: false }
      format.pdf do
        pdf_name = "#{@type.camelize} | #{Date.today.strftime('%d/%m/%Y')}"
        render pdf:            pdf_name,
               disposition:    'attachment',
               layout:         'pdf.html', # use 'pdf.html' for a pdf.html.erb file
               page_offset:    0,
               book:           false,
               orientation:    'Landscape',
               # page_width: '2000',
               # dpi: '300',
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
      format.csv { send_data @branches.to_csv(@data[:columns]) }
      format.xls {
        if @type == AppConstants::Lead_REPORT || @type == AppConstants::VISIT_REPORT || @type == AppConstants::CONTRACTED_REPORT
          send_data Branch.to_branch_status_csv(@branches, @data[:columns])
        end
        
        if @type == AppConstants::ACTIVE_ROUTES_REPORT || @type == AppConstants::NO_WASTE_OIL_REPORT || @type == AppConstants::NOT_VISITED_REPORT
          send_data Branch.to_active_routes_or_no_waste_oil_or_no_visit_csv(@route_branches, @data[:columns])
        end
        
        if @type == AppConstants::MONTH_WISE_COLLECTION_REPORT
          send_data Branch.to_monthly_collection_csv(@branches, @data[:columns], @month_year)
        end
        
        if @type == AppConstants::RESTAURANT_WISE_COLLECTION_REPORT
          send_data Branch.to_restaurant_collection_csv(@branches, @data[:columns], @from_date, @to_date)
        end
        
        if @type == AppConstants::FACTORY_COLLECTION_REPORT
          send_data Branch.to_factory_collection_csv(@route_branches, @data[:columns])
        end
        
        if @type == AppConstants::URGENT_ACTION_REPORT
          send_data Branch.to_urgent_action_csv(@notes, @data[:columns])
        end

        if @type == AppConstants::PROFILING_OF_LEADS_REPORT
          send_data Branch.to_branch_status_csv(@branches, @data[:columns])
        end

        if @type == AppConstants::PROOF_OF_SALE_REPORT
          send_data ProductSale.to_csv(@product_sales, @data[:columns])
        end

        if @type == AppConstants::TRUCK_REPORT
          send_data Vehicle.to_csv(@truck_report_data)
        end

        
      }
    end
  end
  
  def lead_report(params)
    company_ids = Company.where(site_id: @current_user_site.id).pluck(:id)
    @branches   = Branch.where(branch_status: AppConstants::LEAD, company_id: company_ids).includes(:area, :city, :state, :company)
    
    if params[:from_date].present?
      @branches = @branches.where('DATE(created_at) >= DATE(?)', params[:from_date].to_date)
    end
    
    if params[:to_date].present?
      @branches = @branches.where('DATE(created_at) <= DATE(?)', params[:to_date].to_date)
    end
    
    if params[:area_wise].present?
      @branches = @branches.where(area_id: params[:area_wise])
    end
    
    if params[:sale_rep_wise].present?
      @branches = @branches.where(representative: params[:sale_rep_wise])
    end
    @branches
  end
  
  def visit_report(params)
    company_ids = Company.where(site_id: @current_user_site.id).pluck(:id)
    @branches   = Branch.where(branch_status: AppConstants::VISIT, company_id: company_ids).includes(:area, :city, :state, :company)
    
    if params[:from_date].present?
      @branches = @branches.where('DATE(created_at) >= DATE(?)', params[:from_date].to_date)
    end
    
    if params[:to_date].present?
      @branches = @branches.where('DATE(created_at) <= DATE(?)', params[:to_date].to_date)
    end
    
    if params[:area_wise].present?
      @branches = @branches.where(area_id: params[:area_wise])
    end
    
    if params[:sale_rep_wise].present?
      @branches = @branches.where(representative: params[:sale_rep_wise])
    end
    @branches
  end
  
  def contracted_report(params)
    company_ids = Company.where(site_id: @current_user_site.id).pluck(:id)
    branches    = Branch.joins(:company).where(branch_status: AppConstants::CONTRACTED, company_id: company_ids).order('company_code ASC, branch_code ASC').includes(:area, :city, :state)
    
    if params[:from_date].present?
      branches = branches.where('DATE(created_at) >= DATE(?)', params[:from_date].to_date)
    end
    
    if params[:to_date].present?
      branches = branches.where('DATE(created_at) <= DATE(?)', params[:to_date].to_date)
    end
    
    if params[:area_wise].present?
      branches = branches.where(area_id: params[:area_wise])
    end
    
    if params[:sale_rep_wise].present?
      branches = branches.where(representative: params[:sale_rep_wise])
    end
    branches
  end
  
  def factory_collection(params)
    @factory_collections = FactoryCollection.all
    if params[:from_date].present?
      @factory_collections = @factory_collections.where('DATE(created_at) >= DATE(?)', params[:from_date].to_date)
    end
    
    if params[:to_date].present?
      @factory_collections = @factory_collections.where('DATE(created_at) <= DATE(?)', params[:to_date].to_date)
    end
    
    @factory_collections
  end
  
  def active_route_report(params)
    # @routes = Route.active_routes.joins('LEFT JOIN "route_branches" ON "route_branches"."route_id" = "routes"."id"').uniq.order('id ASC').includes(:route_branches)
    @routes = Route.active_routes.where(site_id: @current_user_site.id)
    if params[:from_date].present?
      @routes = @routes.where('DATE(created_at) >= DATE(?)', params[:from_date].to_date)
    end
    
    if params[:to_date].present?
      @routes = @routes.where('DATE(created_at) <= DATE(?)', params[:to_date].to_date)
    end
    
    if params[:state_wise].present?
      @routes = @routes.where(state_id: params[:state_wise])
    end
    
    if params[:city_wise].present?
      @routes = @routes.where(city_id: params[:city_wise])
    end
    @route_branches = RouteBranch.where('route_id IN(?) AND is_deleted = false AND transfer_to IS NULL', @routes.pluck(:id)).includes(:branch).order('route_id ASC')
    @states         = State.where(id: @routes.pluck(:state_id))
    @cities         = City.where(id: @routes.pluck(:city_id))
    ids             = @routes.pluck(:areas).flatten.uniq
    @areas          = Area.where(id: ids)
    [@route_branches, @states, @cities, @areas]
  end
  
  def no_waste_oil_report(params)
    route_ids       = Route.where(site_id: @current_user_site.id, is_completed: true).pluck(:id)
    @route_branches = RouteBranch.where(quantity: 0, is_deleted: false, transfer_to: nil, route_id: route_ids).includes(:route).order('route_id ASC')
    
    if params[:from_date].present?
      @route_branches = @route_branches.where('DATE(created_at) >= DATE(?)', params[:from_date].to_date)
    end
    
    if params[:to_date].present?
      @route_branches = @route_branches.where('DATE(created_at) <= DATE(?)', params[:to_date].to_date)
    end
    
    if params[:branch_wise].present?
      @route_branches = @route_branches.where(branch_id: params[:branch_wise])
    end
    
    @branches = Branch.where(id: @route_branches.pluck(:branch_id).uniq)
    [@route_branches, @branches]
  end
  
  def not_visited_report(params)
    route_ids       = Route.where(is_deleted: false, site_id: @current_user_site.id)
    @route_branches = RouteBranch.where(is_deleted: true, route_id: route_ids).includes(:branch, :route).order('route_id DESC')
    if params[:from_date].present?
      @route_branches = @route_branches.where('DATE(created_at) >= DATE(?)', params[:from_date].to_date)
    end
    
    if params[:to_date].present?
      @route_branches = @route_branches.where('DATE(created_at) <= DATE(?)', params[:to_date].to_date)
    end
    @route_branches
  end
  
  def profiling_of_leads_report(params)
    contract_type = params[:contract_type]
    company_ids   = Company.where(site_id: @current_user_site.id).pluck(:id)
    branches      = Branch.joins(:company).where(contract_type: contract_type, company_id: company_ids).order('company_code ASC, branch_code ASC').includes(:area, :city, :state)
    
    if params[:area_wise].present?
      branches = branches.where(area_id: params[:area_wise])
    end
    
    if params[:sale_rep_wise].present?
      branches = branches.where(representative: params[:sale_rep_wise])
    end
    branches
  end
  
  def proof_sale_report(params)
    product_sales = ProductSale.where(site_id: @current_user_site.id)
    
    if params[:country_wise].present?
      product_sales = product_sales.where(country_name: params[:country_wise])
    end
    
    if params[:from_date].present?
      product_sales = product_sales.where('DATE(sale_date) >= DATE(?)', params[:from_date].to_date)
    end
    
    if params[:to_date].present?
      product_sales = product_sales.where('DATE(sale_date) <= DATE(?)', params[:to_date].to_date)
    end
    product_sales
  end
  
  def truck_report(params)
    truck_report_data = []
    vehicles          = Vehicle.where(is_deleted: false, site_id: @current_user_site.id)
    vehicles.each do |vehicle|
      assignments = Assignment.where(vehicle_id: vehicle.id, site_id: @current_user_site.id, is_completed: true, is_deleted: false)
      
      if params[:from_date].present?
        assignments = assignments.where('DATE(created_at) >= DATE(?)', params[:from_date].to_date)
      end
      
      if params[:to_date].present?
        assignments = assignments.where('DATE(created_at) <= DATE(?)', params[:to_date].to_date)
      end
      route_ids       = assignments.pluck(:route_id)
      @route_branches = RouteBranch.where(is_deleted: false, route_id: route_ids)
      truck_report_data << {
          vehicle:                vehicle,
          total_oil_collected:    @route_branches.sum(:quantity),
          total_branches_visited: @route_branches.count
      }
    end
    
    truck_report_data
  end
end
