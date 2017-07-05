class ApplicationController < ActionController::Base
  include Pundit
  protect_from_forgery with: :exception
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  before_filter :authenticate_user!
  
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
end
