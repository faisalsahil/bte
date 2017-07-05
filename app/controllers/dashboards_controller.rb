class DashboardsController < ApplicationController
  def index
    @users     = User.count
    @companies = Company.count
    @branches  = Branch.count
    @vehicles  = Vehicle.count
  end
end
