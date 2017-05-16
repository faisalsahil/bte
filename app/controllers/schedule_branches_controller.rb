class ScheduleBranchesController < ApplicationController
  
  def schedules
    respond_to do |format|
      # @vehicles = current_user.vehicles
      @vehicles = User.where(role_id: 3).first.vehicles
      if params[:date].present? && params[:vehicle_id].present?
        @date    = params[:date]
        @day     = Date.parse(params[:date]).strftime('%A').downcase
        @vehicle = params[:vehicle_id]
        @scheduled_branches = ScheduleBranch.includes(:branch, :vehicle).where(vehicle_id: @vehicle, schedule_day: @day)
        @collections        = Collection.where('vehicle_id = ? AND DATE(collected_at) = DATE(?)', @vehicle, @date.to_date.strftime('%Y-%m-%d'))
      end
  
      format.html
      format.js { render layout: false }
      format.pdf do
        @vehicle = Vehicle.find_by_id(@vehicle)
        pdf_name = "#{@day.camelize} | #{@vehicle.vehicle_number}"
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
                       template: '/schedule_branches/header.pdf.erb', # use :template OR :url
                       layout: 'pdf.html' # optional, use 'pdf_plain.html' for a pdf_plain.html.erb file, defaults to main layout
                   },
                   font_name: 'Times New Roman',
                   font_size: 14,
                   line: false
               }, # optionally you can pass plain html already rendered (useful if using pdf_from_string)
               footer: {
                   html: {
                       template: '/schedule_branches/footer.pdf.erb', # use :template OR :url
                       layout: 'pdf.html' # optional, use 'pdf_plain.html' for a pdf_plain.html.erb file, defaults to main layout
                   },
                   font_name: 'Times New Roman',
                   font_size: 14,
                   line: true
               }
      end
    end
  end
  
  
end
