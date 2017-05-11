module Authentication

  def self.included(controller)
    controller.send :helper_method, :current_profile, :current_user,
                    :logged_in?,
                    :redirect_to_target_or_default,
                    :redirect_target_or_default,
                    :support_login?, :support_user_id, :readonly_login?
  end

  def current_profile_session
    # return @current_profile_session if defined?(@current_profile_session)
    @current_profile_session = session[:user_session]
  end

  def current_profile
    @current_profile = HashToObject.convert(current_profile_session).member_profile if current_profile_session.present?
  end

  def current_user
    @current_user = current_profile.user if current_profile.present?
  end

  def reset_current_profile_session
    @current_profile_session = session[:user_session]
  end

  def destroy_and_clear_session
    session[:user_session] = nil
    reset_current_profile_session
  end


  def logged_in?
    current_profile
  end

  def require_no_user
    if logged_in?
      store_target_location
      flash[:notice]      = "You must be logged out to access this page"
      session[:logged_in] = true
      redirect_to home_url
      return false
    end
  end


  def login_required
    unless logged_in?
      flash[:error] = "You must first log in or sign up before accessing this page."
      store_target_location

      redirect_to login_url
    end
  end

  def redirect_to_target_or_default(default)
    redirect_to(session[:return_to] || default)
    session[:return_to] = nil
  end

  def redirect_target_or_default(default)
    session[:return_to] || default
  end

  private
  def store_target_location
    session[:return_to] = request.fullpath unless request.fullpath.match /#{logout_path}/
  end
end
