class DashboardsController < ApplicationController
  before_action :authenticate_user!
  
  def index
    @users     = User.count
    @companies = Company.count
    @branches  = Branch.count
    @vehicles  = Vehicle.count
  end
end
