class UsersController < ApplicationController
  load_and_authorize_resource
  
  def index
    if @current_user_role == AppConstants::SUPER_ADMIN
      role_id = Role.find_by_name(AppConstants::ADMIN).try(:id)
      @users  = User.where('role_id = ? AND site_id IS NOT NULL', role_id)
    end
    # @users = @user
  end
  
  def new
    @user = User.new
  end
  
  def add_user
    # authorize :user
    if params[:user][:email].present? && params[:user][:password].present? && params[:user][:password_confirmation].present?
      user = User.new(user_params)
      if params[:user][:role_id].blank?
        user.role_id = Role.find_by_name(AppConstants::ADMIN).id
      end
      user.site_id = params[:user][:site_id]
      if user.save!
        redirect_to root_url
      else
        flash[:error] = user.errors.messages
        render :new
      end
    else
      flash[:error] = 'Please fill all fields'
      render :new
    end
  end
  
  def block_unblock_user
    authorize :user
    user = User.find_by_id(params[:id])
    if user.present?
      if user.is_deleted
        user.is_deleted = false
      else
        user.is_deleted = true
      end
      user.save!
    end
    redirect_to users_path
  end
  
  private
  
  def user_params
    accessible = [:name, :email, :role_id, :site_id] # extend with your own params
    accessible << [:password, :password_confirmation] unless params[:user][:password].blank?
    params.require(:user).permit(accessible)
  end
end
