class FactoryCollectionsController < ApplicationController
  
  def index
    authorize :factory_collection
    @factory_collections = FactoryCollection.all.includes(:route_branches)
  end
  
  def show
    authorize :factory_collection
    @factory_collection = FactoryCollection.find_by_id(params[:id])
    @route_branches     = @factory_collection.route_branches.order('route_id ASC').includes(:route)

    respond_to do |format|
      format.html {  }
      format.pdf do
        pdf_name = "FactoryCollection | #{@factory_collection.id}"
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
end
