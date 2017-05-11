class UsersController < ApplicationController
  
  def index
    @users = User.all
  end
  
  def new
    @user = User.new
  end
  
  def add_user
    if params[:user][:email].present? && params[:user][:password].present? && params[:user][:password_confirmation].present?
      user = User.new(user_params)
      if user.save
        redirect_to users_path
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
    accessible = [:name, :email, :role_id] # extend with your own params
    accessible << [:password, :password_confirmation] unless params[:user][:password].blank?
    params.require(:user).permit(accessible)
  end
end
