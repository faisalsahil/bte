class Branch < ApplicationRecord

  validates_presence_of :rate_per_kg

  geocoded_by :address
  after_validation :geocode, if: ->(obj){ !obj.latitude.present? and !obj.longitude.present? }

  reverse_geocoded_by :latitude, :longitude
  after_validation :reverse_geocode

  has_many :route_branches
  has_many :routes, through: :route_branches
  has_many :transactions
  has_many :notes
  belongs_to :area
  belongs_to :storage_type
  belongs_to :food_type
  belongs_to :state
  belongs_to :city
  belongs_to :company, inverse_of: :branches

  attr_accessor :contact_same_as_above

  belongs_to :representator, class_name:  :User, foreign_key: :representative

  def address
    [street, city.try(:name), state.try(:name), zip].compact.join(', ')
  end

  def update_status_and_code
    branch_status = self.branch_status
    if branch_status == AppConstants::CONTRACTED
      company = self.company
      # assign company code if blank
      if company.company_code == 0
        code  = Company.order('company_code desc').limit(1).try(:first).try(:company_code)
        company.company_status = AppConstants::CONTRACTED
        company.company_code   = code + 1
        company.save(validate: false)
      end
      # assign branch code to branch
      if self.branch_code == 0
        branch_code = company.branches.where(branch_status: AppConstants::CONTRACTED).order('branch_code desc').limit(1).try(:first).try(:branch_code) || 0
        self.branch_code = branch_code + 1
        self.save(validate: false)
      end
    end
  end

  def total_collection
    self.route_branches.sum(:quantity)
  end
  
  def self.total_month_collection(branch, date)
    branch.route_branches.where('transfer_to IS NULL AND is_deleted = false AND extract(month from created_at) = ? AND extract(year from created_at) = ?', date.to_date.month, date.to_date.year).sum(:quantity)
  end

  def self.total_restaurant_collection(branch, fromdate, todate)
    if fromdate.present? && todate.present?
      branch.route_branches.where('transfer_to IS NULL AND is_deleted = false AND DATE(created_at) >= DATE(?) AND DATE(created_at) <= DATE(?)', fromdate.to_date, todate.to_date).sum(:quantity)
    elsif fromdate.present?
      branch.route_branches.where('transfer_to IS NULL AND is_deleted = false AND DATE(created_at) >= DATE(?)', fromdate.to_date).sum(:quantity)
    elsif todate.present?
      branch.route_branches.where('transfer_to IS NULL AND is_deleted = false AND DATE(created_at) <= DATE(?)', todate.to_date).sum(:quantity)
    else
      branch.route_branches.where('transfer_to IS NULL AND is_deleted = false').sum(:quantity)
    end
  end

  def self.sort_branches(branch_ids)
    @branches = Branch.joins(:company).where(id: branch_ids).order('company_code ASC, branch_code ASC').includes(:area)
  end
  
  def current_month_remaining_visits
    remaining_visits = 0
    remaining_visits = self.visits_per_month - self.route_branches.where("route_branches.transfer_to IS NULL AND route_branches.is_deleted != 't' AND extract(month from route_branches.created_at) = #{Date.today.month}").count rescue 0
    remaining_visits
  end

  def self.to_branch_status_csv(branches, columns = {})
    @columns = columns.split(',')
    CSV.generate do |csv|
      csv << @columns
      branches.each do |branch|
        ar = []
        ar << branch.area.name if @columns.include? 'area_id'
        ar << branch.try(:representator).try(:name) || 'N/A' if @columns.include? 'representative'
        ar << branch.branch_name if @columns.include? 'branch_name'
        ar << "#{branch.company.company_code}/#{branch.branch_code}" if @columns.include? 'branch_code'
        ar << branch.contact_name if @columns.include? 'contact_name'
        ar << branch.contact_phone if @columns.include? 'contact_phone'
        ar << branch.monthly_oil_used if @columns.include? 'monthly_oil_used'
        ar << branch.rate_per_kg if @columns.include? 'rate_per_kg'
        ar << branch.visits_per_month if @columns.include? 'visits_per_month'
        ar << branch.total_collection if @columns.include? 'total_collection'
        ar << branch.address if @columns.include? 'address'
      
        csv << ar
      end
    end
  end

  def self.to_active_routes_or_no_waste_oil_or_no_visit_csv(route_branches, columns = {})
    @columns = columns.split(',')
    CSV.generate do |csv|
      csv << @columns
      route_branches.each do |route_branch|
        assignment = route_branch.route.assignment
        ar = []
        ar << "Route-#{route_branch.route_id}/#{route_branch.id} " if @columns.include? 'voucher'
        ar << route_branch.branch.branch_name if @columns.include? 'branch_name'
        ar << "#{route_branch.branch.try(:company).try(:company_code)}/#{route_branch.branch.branch_code}"  if @columns.include? 'branch_code'
        ar << route_branch.quantity if @columns.include? 'quantity'
        ar << assignment.try(:driver).try(:name) || 'N/A'  if @columns.include? 'driver'
        ar << assignment.try(:helper).try(:name)  || 'N/A' if @columns.include? 'helper'
        ar << assignment.try(:vehicle).try(:vehicle_number) || 'N/A' if @columns.include? 'vehicle'
        ar << route_branch.comment if @columns.include? 'comment'
      
        csv << ar
      end
    end
  end

  def self.to_monthly_collection_csv(branches, columns = {}, month_year)
    @columns = columns.split(',')
    CSV.generate do |csv|
      csv << @columns
      branches.each do |branch|
        ar = []
        ar << branch.area.name if @columns.include? 'area_id'
        ar << branch.try(:representator).try(:name) || 'N/A' if @columns.include? 'representative'
        ar << branch.branch_name if @columns.include? 'branch_name'
        ar << "#{branch.company.company_code}/#{branch.branch_code}" if @columns.include? 'branch_code'
        ar << branch.contact_name if @columns.include? 'contact_name'
        ar << branch.contact_phone if @columns.include? 'contact_phone'
        ar << Branch.total_month_collection(branch, month_year) if @columns.include? 'total_collection'
        ar << branch.rate_per_kg if @columns.include? 'rate_per_kg'
        ar << branch.address if @columns.include? 'address'
      
        csv << ar
      end
    end
  end

  def self.to_restaurant_collection_csv(branches, columns = {}, from_date, to_date)
    @columns = columns.split(',')
    CSV.generate do |csv|
      csv << @columns
      branches.each do |branch|
        ar = []
        ar << branch.area.name if @columns.include? 'area_id'
        ar << branch.try(:representator).try(:name) || 'N/A' if @columns.include? 'representative'
        ar << branch.branch_name if @columns.include? 'branch_name'
        ar << "#{branch.company.company_code}/#{branch.branch_code}" if @columns.include? 'branch_code'
        ar << branch.contact_name if @columns.include? 'contact_name'
        ar << branch.contact_phone if @columns.include? 'contact_phone'
        ar << Branch.total_restaurant_collection(branch, from_date, to_date)if @columns.include? 'total_collection'
        ar << branch.rate_per_kg if @columns.include? 'rate_per_kg'
        ar << branch.address if @columns.include? 'address'
        
        csv << ar
      end
    end
  end
  
  def self.to_factory_collection_csv(route_branches, columns = {})
    @columns = columns.split(',')
    CSV.generate do |csv|
      csv << @columns
      route_branches.each do |route_branch|
        assignment = route_branch.route.assignment
        ar = []
        ar << route_branch.factory_collection_id if @columns.include? 'factory_collection_id'
        ar << "Route-#{route_branch.route_id}/#{route_branch.id}" if @columns.include? 'voucher'
        ar << route_branch.branch.branch_name if @columns.include? 'branch_name'
        ar << "#{route_branch.branch.try(:company).try(:company_code)}/#{route_branch.branch.branch_code}" if @columns.include? 'branch_code'
        ar << route_branch.quantity if @columns.include? 'quantity'
        ar << assignment.try(:driver).try(:name) || 'N/A' if @columns.include? 'driver'
        ar << assignment.try(:helper).try(:name)  || 'N/A' if @columns.include? 'helper'
        ar << assignment.try(:vehicle).try(:vehicle_number) || 'N/A' if @columns.include? 'vehicle'
        ar << route_branch.comment if @columns.include? 'comment'
        
        csv << ar
      end
    end
  end
end
