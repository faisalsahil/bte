class Branch < ApplicationRecord

  validates_presence_of :rate_per_kg

  geocoded_by :address
  after_validation :geocode, if: ->(obj){ !obj.latitude.present? and !obj.longitude.present? }

  reverse_geocoded_by :latitude, :longitude
  after_validation :reverse_geocode
  
  has_many :route_branches
  has_many :routes, through: :route_branches
  has_many :transactions
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
end
