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
  
  def self.to_csv(columns = {})
    CSV.generate do |csv|
      csv << columns.split(',')
      all.each do |branch|
        csv << [branch.branch_name, branch.branch_code, branch.rate_per_kg]
      end
    end
  end

  def current_month_remaining_visits
    remaining_visits = 0
    remaining_visits = self.visits_per_month - self.route_branches.where("route_branches.transfer_to IS NULL AND route_branches.is_deleted != 't' AND extract(month from route_branches.created_at) = #{Date.today.month}").count rescue 0
    remaining_visits
  end
end
