class BillingsController < ApplicationController
  # load_and_authorize_resource
  before_action :set_billing, only: [:show, :edit, :update, :destroy]
  
  def index
    authorize :billing
    if params[:date].present?
      @date = params[:date].to_date
      
      @route_ids    = Assignment.where('assignment_status = ? AND extract(month from assigned_at) = ? AND extract(year from assigned_at) = ? AND site_id = ?', AppConstants::COMPLETED, @date.month, @date.year, @current_user_site.id).pluck(:route_id)
      
      
      @branch_ids   = RouteBranch.where(route_id: @route_ids).pluck(:branch_id).uniq
      @branches     = Branch.where(id: @branch_ids).includes(:company)
      @transactions = Transaction.where(branch_id: @branch_ids)
    end
    respond_to do |format|
      format.html {}
      format.pdf do
        pdf_name = "Invoice | #{Date.today.strftime('%m/%Y')}"
        render pdf:            pdf_name,
               disposition:    'attachment',
               layout:         'pdf.html', # use 'pdf.html' for a pdf.html.erb file
               page_offset:    0,
               book:           false,
               default_header: true,
               lowquality:     false,
               # save_only:       true,
               margin:         { bottom: 10, top: 15 },
               header:         {
                   html:      {
                       template: '/shared/invoice_header.pdf.erb', # use :template OR :url
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
      format.xls { send_data @branches.to_csv(@data[:columns]) }
    end
  end
  
  def invoice
    authorize :billing
    @date           = params[:date].to_date
    @branch         = Branch.find_by_id(params[:id])
    @route_ids = Assignment.where('assignment_status = ? AND extract(month from assigned_at) = ? AND extract(year from assigned_at) = ?',AppConstants::COMPLETED, @date.month, @date.year).pluck(:route_id)
    # @route_ids = Assignment.where('extract(month from assigned_at) = ? AND extract(year from assigned_at) = ?', @date.month, @date.year).pluck(:route_id)
    
    # @total     = RouteBranch.where(branch_id: @branch.id, route_id: @route_ids).sum('quantity * price')
    @route_branches = RouteBranch.where(branch_id: @branch.id, route_id: @route_ids, is_deleted: false, transfer_to: nil)
    @paid = Transaction.where('branch_id = ? AND extract(month from transaction_date) = ?', @branch.id, @date.month).sum(:amount) || 0
    respond_to do |format|
      format.pdf do
        pdf_name = "#{@branch.branch_name} | #{Date.today.strftime('%m/%Y')} | Invoice"
        render pdf:            pdf_name,
               disposition:    'attachment',
               layout:         'pdf.html', # use 'pdf.html' for a pdf.html.erb file
               page_offset:    0,
               book:           false,
               default_header: true,
               lowquality:     false,
               # save_only:       true,
               margin:         { bottom: 10, top: 15 },
               header:         {
                   html:      {
                       template: '/shared/invoice_header.pdf.erb', # use :template OR :url
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
      format.xls { send_data @branches.to_csv(@data[:columns]) }
    end
  end
  
  # def invoice_all
  #   authorize :billing
  #   @date      = params[:date].to_date
  #   @route_ids = Assignment.where('assignment_status != ? AND extract(month from assigned_at) = ? AND extract(year from assigned_at) = ?', AppConstants::ACTIVE, @date.month, @date.year).pluck(:route_id)
  #   # @route_ids = Assignment.where('assignment_status != ? AND extract(month from assigned_at) = ?',AppConstants::ACTIVE, @date.month).pluck(:route_id)
  # end
end
