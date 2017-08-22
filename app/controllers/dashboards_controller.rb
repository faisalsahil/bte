class DashboardsController < ApplicationController
  
  def index
    if params[:site_id].present?
      @current_user_site          = Site.find_by_id(params[:site_id])
      session[:current_user_site] = @current_user_site
    elsif @current_user_role == AppConstants::PFA
      session.delete(:current_user_site)
      @current_user_site = nil
    end
    
    if @current_user_role == AppConstants::PFA
      @sites = Site.all
      if @current_user_site != nil
        site_id      = @current_user_site.id
        @users       = User.where(site_id: site_id)
        @companies   = Company.where(site_id: site_id)
        companies_id = @companies.pluck(:id)
        @branches    = Branch.where(branch_status: AppConstants::CONTRACTED, company_id: companies_id)
        @vehicles    = Vehicle.where(site_id: site_id)
      end
    elsif @current_user_role == AppConstants::SUPER_ADMIN
      @sites = Site.all
    end
    
    if @current_user_site.present?
      company_ids                    = Company.where(site_id: @current_user_site.id).pluck(:id)
      # Contracts Count
      @total_contracts_count         = Branch.where(branch_status: AppConstants::CONTRACTED, company_id: company_ids).count
      @current_month_contracts_count = Branch.where('branch_status = ? AND company_id IN (?) AND extract(month from created_at) = ?', AppConstants::CONTRACTED, company_ids, Date.today.month).count
  
      # Leads Count
      @total_leads_count             = Branch.where(branch_status: AppConstants::LEAD, company_id: company_ids).count
      @current_month_leads_count     = Branch.where('branch_status = ? AND company_id IN (?) AND extract(month from created_at) = ?', AppConstants::LEAD, company_ids, Date.today.month).count
  
      # OIL Collection Count
      route_ids                      = Assignment.where('site_id = ? AND is_completed = ? AND is_deleted = ? ', @current_user_site.id, true, false).pluck(:route_id)
      @total_oil_collected           = RouteBranch.where(route_id: route_ids, is_deleted: false, transfer_to: nil).sum(:quantity)
      route_branches                 = RouteBranch.where('route_id IN (?) AND is_deleted = ? AND extract(month from collected_date) = ?', route_ids, false, Date.today.month)
      @current_month_oil_collected   = route_branches.where(transfer_to: nil).sum(:quantity)
  
      # Urgent Action count
      @total_notes                   = Note.where(site_id: @current_user_site.id).count
      @total_unresolved_notes        = Note.where(site_id: @current_user_site.id, completed_notes: nil).count
  
      # Proof of Sale Count
      route_ids                      = Assignment.where(site_id: @current_user_site.id, is_completed: true).pluck(:route_id)
      @total_collected               = RouteBranch.where(route_id: route_ids).sum(:quantity) || 0
      @total_sold                    = @current_user_site.product_sales.sum(:quantity) || 0
    end
  
  
  end
end
