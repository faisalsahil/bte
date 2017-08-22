class Site < ApplicationRecord
  has_many :product_sales
  has_many :users
  
  validates :ntn, presence: true
  validates :name, presence: true
  validates :name, uniqueness: true, if: 'name.present?'
  
  accepts_nested_attributes_for :product_sales
  
  def self.site_data_for_pfa_dashboard(site)
    company_ids            = Company.where(site_id: site.id).pluck(:id)
    @total_contracts_count = Branch.where(branch_status: AppConstants::CONTRACTED, company_id: company_ids).count
    
    # Oil Collection
    route_ids              = Assignment.where('site_id = ? AND is_completed = ? AND is_deleted = ? ', site.id, true, false).pluck(:route_id)
    @total_oil_collected   = RouteBranch.where(route_id: route_ids, is_deleted: false, transfer_to: nil).sum(:quantity)
  
    [@total_contracts_count, @total_oil_collected]
  end
end
