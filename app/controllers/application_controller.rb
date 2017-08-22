class ApplicationController < ActionController::Base
  include Pundit
  protect_from_forgery with: :exception
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  before_filter :authenticate_user!
  before_action :set_current_user_role, :set_current_user_site
  
  layout :determine_layout
  
  def determine_layout
    if user_signed_in?
      "application"
    else
      "signin_layout"
    end
  end
  
  private
  
  def user_not_authorized
    flash[:warning] = "Access denied."
    redirect_to (request.referrer || root_url)
  end
  
  def set_current_user_role
    @current_user_role = current_user.role.name if current_user.present?
  end
  
  def set_current_user_site
    if current_user.present?
      if @current_user_role == AppConstants::PFA
        @current_user_site = session[:current_user_site] || nil
        @current_user_site = Site.find_by_id(@current_user_site['id']) if @current_user_site != nil
      else
        @current_user_site = current_user.site
      end
    end
  end
end
