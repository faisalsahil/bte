class ReportsController < ApplicationController
  
  def index
  end
  
  def generate_report
    @from_date = params[:from_date].try(:to_date)
    @to_date   = params[:to_date].try(:to_date)
    @type      = params[:report_type]
    
    if @type == AppConstants::Lead_REPORT
      @branches = Branch.where(branch_status: AppConstants::LEAD)
    end
    respond_to do |format|
      format.html { redirect_to reports_path }
      format.js { render layout: false }
      # format.pdf do
      #   pdf_name = "#{@type.camelize} | #{Date.today.strftime('%d/%m/%Y')}"
      #   render pdf: pdf_name,
      #          disposition: 'inline',
      #          layout: 'pdf.html', # use 'pdf.html' for a pdf.html.erb file
      #          page_offset: 0,
      #          book: false,
      #          default_header: true,
      #          lowquality: false,
      #          # save_only:       true,
      #          margin: {bottom: 10, top: 15},
      #          header: {
      #              html: {
      #                  template: '/assignments/header.pdf.erb', # use :template OR :url
      #                  layout: 'pdf.html' # optional, use 'pdf_plain.html' for a pdf_plain.html.erb file, defaults to main layout
      #              },
      #              font_name: 'Times New Roman',
      #              font_size: 8,
      #              margin: {left: 0},
      #              line: false
      #          }, # optionally you can pass plain html already rendered (useful if using pdf_from_string)
      #          footer: {
      #              html: {
      #                  template: '/assignments/footer.pdf.erb', # use :template OR :url
      #                  layout: 'pdf.html' # optional, use 'pdf_plain.html' for a pdf_plain.html.erb file, defaults to main layout
      #              },
      #              font_name: 'Times New Roman',
      #              font_size: 8,
      #              line: true
      #          }
      # end
    end
    
  end
  
end
