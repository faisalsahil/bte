class SitesController < ApplicationController
  load_and_authorize_resource
  before_action :set_site, only: [:show, :edit, :update, :destroy]
  
  def index
    @sites = Site.all
  end
  
  def show
  end
  
  def new
    @site = Site.new
  end
  
  def edit
  end
  
  def create
    @site = Site.new(site_params)
    # Creating default recored
    respond_to do |format|
      if @site.save
        StorageType.create!(name: 'N/A', site_id: @site.id)
        FoodType.create!(name: 'N/A', site_id: @site.id)
        Company.create!(company_name: 'N/A', site_id: @site.id)
        Vehicle.create!(vehicle_type: 'N/A', vehicle_number: 'N/A', site_id: @site.id)
        driver_role = Role.find_by_name(AppConstants::DRIVER)
        helper_role = Role.find_by_name(AppConstants::HELPER)
        user        = User.new(name: "#{@site.name} driver", email: "#{@site.name}_driver@gmail.com", password: '123456789', password_confirmation: '123456789', site_id: @site.id, role_id: driver_role.id)
        user.save!
        user = User.new(name: "#{@site.name} helper", email: "#{@site.name}_helper@gmail.com", password: '123456789', password_confirmation: '123456789', site_id: @site.id, role_id: helper_role.id)
        user.save!
        format.html { redirect_to @site, notice: 'Site was successfully created.' }
        format.json { render :show, status: :created, location: @site }
      else
        format.html { render :new }
        format.json { render json: @site.errors, status: :unprocessable_entity }
      end
    end
  end
  
  
  def site_product_sale
    @site = Site.find_by_id(@current_user_site.id)
    respond_to do |format|
      if @site.update(site_params)
        @site.product_sales.where(gd_number: '', quantity: nil).destroy_all
        @site.product_sales.each do |product_sale|
          country      = ISO3166::Country[product_sale.country]
          if country.present? && country.name.present?
            product_sale.country_name = country.name
            product_sale.save!
          end
        end
        format.html { redirect_to product_sales_path, notice: 'Site was successfully updated.' }
        format.json { render :show, status: :ok, location: @site }
      else
        format.html { render :edit }
        format.json { render json: @site.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def update
    respond_to do |format|
      if @site.update(site_params)
        @site.product_sales.where(gd_number: '', quantity: nil).destroy_all
        format.html { redirect_to @site, notice: 'Site was successfully updated.' }
        format.json { render :show, status: :ok, location: @site }
      else
        format.html { render :edit }
        format.json { render json: @site.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def destroy
    @site.destroy
    respond_to do |format|
      format.html { redirect_to sites_url, notice: 'Site was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
  
  private
  def set_site
    @site = Site.find(params[:id])
  end
  
  def site_params
    params.require(:site).permit(:name, :is_automate_process, product_sales_attributes: [:sale_date, :country, :country_name, :gd_number, :quantity, :attachment, :remarks, :stock_in_hand, :site_id])
  end
end
