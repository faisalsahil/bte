class ReportsController < ApplicationController
  
  def index
  end
  
  def generate_report
    @from_date = params[:from_date].try(:to_date)
    @to_date   = params[:to_date].try(:to_date)
    @type      = params[:report_type]
    puts "xXXx"*90
    puts params.inspect
    puts "XX"*90
    
    if @type == AppConstants::Lead_REPORT
      @branches = lead_report(params)
      @data = params
    end
    
    if @type == AppConstants::VISIT_REPORT
      @branches = visit_report(params)
      @data = params
    end
    
    if @type == AppConstants::CONTRACTED_REPORT
      @branches = contracted_report(params)
      @data = params
    end

    if @type == AppConstants::ACTIVE_ROUTES_REPORT
      @routes = Route.active_routes.joins(:route_branches).where('route_branches.is_deleted = false AND transfer_to IS NULL').uniq.order('id ASC')
    end
    
    respond_to do |format|
      format.html { redirect_to reports_path }
      format.js { render layout: false }
      format.pdf do
        pdf_name = "#{@type.camelize} | #{Date.today.strftime('%d/%m/%Y')}"
        render pdf: pdf_name,
               disposition: 'attachment',
               layout: 'pdf.html', # use 'pdf.html' for a pdf.html.erb file
               page_offset: 0,
               book: false,
               default_header: true,
               lowquality: false,
               # save_only:       true,
               margin: {bottom: 10, top: 15},
               header: {
                   html: {
                       template: '/shared/header.pdf.erb', # use :template OR :url
                       layout: 'pdf.html' # optional, use 'pdf_plain.html' for a pdf_plain.html.erb file, defaults to main layout
                   },
                   font_name: 'Times New Roman',
                   font_size: 8,
                   margin: {left: 0},
                   line: false
               }, # optionally you can pass plain html already rendered (useful if using pdf_from_string)
               footer: {
                   html: {
                       template: '/shared/footer.pdf.erb', # use :template OR :url
                       layout: 'pdf.html' # optional, use 'pdf_plain.html' for a pdf_plain.html.erb file, defaults to main layout
                   },
                   font_name: 'Times New Roman',
                   font_size: 8,
                   line: true
               }
      end
    end
    
  end
  
  
  def lead_report(params)
    @branches = Branch.where(branch_status: AppConstants::LEAD).includes(:area, :city, :state, :company)
    
    if params[:from_date].present?
      @branches.where('DATE(created_at) >= DATE(?)', params[:from_date].to_date)
    end

    if params[:to_date].present?
      @branches.where('DATE(created_at) <= DATE(?)', params[:to_date].to_date)
    end
    
    if params[:area_wise].present?
      @branches.where(area_id: params[:area_wise])
    end

    if params[:sale_rep_wise].present?
      @branches.where(representative: params[:sale_rep_wise])
    end
    @branches
  end
  
  def visit_report(params)
    @branches = Branch.where(branch_status: AppConstants::VISIT).includes(:area, :city, :state, :company)
  
    if params[:from_date].present?
      @branches.where('DATE(created_at) >= DATE(?)', params[:from_date].to_date)
    end
  
    if params[:to_date].present?
      @branches.where('DATE(created_at) <= DATE(?)', params[:to_date].to_date)
    end
  
    if params[:area_wise].present?
      @branches.where(area_id: params[:area_wise])
    end
  
    if params[:sale_rep_wise].present?
      @branches.where(representative: params[:sale_rep_wise])
    end
    @branches
  end

  def contracted_report(params)
    @branches = Branch.joins(:company).where(branch_status: AppConstants::CONTRACTED).order('company_code ASC, branch_code ASC').includes(:area, :city, :state)
    if params[:from_date].present?
      @branches.where('DATE(created_at) >= DATE(?)', params[:from_date].to_date)
    end
  
    if params[:to_date].present?
      @branches.where('DATE(created_at) <= DATE(?)', params[:to_date].to_date)
    end
  
    if params[:area_wise].present?
      @branches.where(area_id: params[:area_wise])
    end
  
    if params[:sale_rep_wise].present?
      @branches.where(representative: params[:sale_rep_wise])
    end
    @branches
  end
end
