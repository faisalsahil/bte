class ProductSalesController < ApplicationController
  before_action :set_product_sale, only: [:show, :edit, :update, :destroy]

  def index
    @product_sales = ProductSale.where(site_id: @current_user_site.id)
  end

  def show
  end

  def new
    @site = Site.new
    5.times { @site.product_sales.build }
    route_ids = Assignment.where(site_id: @current_user_site.id, is_completed: true).pluck(:route_id)
    @total_collected = RouteBranch.where(route_id: route_ids).sum(:quantity)
    @total_sold = @current_user_site.product_sales.sum(:quantity)
  end

  def edit
  end

def create
    @product_sale = ProductSale.new(product_sale_params)

    respond_to do |format|
      if @product_sale.save
        format.html { redirect_to @product_sale, notice: 'Product sale was successfully created.' }
        format.json { render :show, status: :created, location: @product_sale }
      else
        format.html { render :new }
        format.json { render json: @product_sale.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @product_sale.update(product_sale_params)
        format.html { redirect_to @product_sale, notice: 'Product sale was successfully updated.' }
        format.json { render :show, status: :ok, location: @product_sale }
      else
        format.html { render :edit }
        format.json { render json: @product_sale.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @product_sale.destroy
    respond_to do |format|
      format.html { redirect_to product_sales_url, notice: 'Product sale was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def set_product_sale
      @product_sale = ProductSale.find(params[:id])
    end

    def product_sale_params
      params.require(:product_sale).permit(:sale_date, :country, :gd_number, :quantity, :attachment, :remarks, :stock_in_hand, :site_id, :income_tax_return_file)
    end
end
