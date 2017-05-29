class Company < ApplicationRecord
  
  has_many :branches
  
  validates_presence_of   :company_name
  validates_uniqueness_of :company_name
  
  accepts_nested_attributes_for :branches
  
  def update_status_and_code
    # if self.company_code == 0 && self.company_status == AppConstants::VISIT
    #   branches = self.branches
    #   code     = Company.order('company_code desc').limit(1).company_code
    #   if branches.present? && branches.where(branch_status: AppConstants::CONTRACTED).present?
    #     self.company_status = AppConstants::CONTRACTED
    #     self.company_code = code.to_i + 1
    #   elsif branches.present? &&  branches.where(branch_status: AppConstants::LEAD).present?
    #     self.company_status = AppConstants::LEAD
    #   end
    #   self.save!
    # end
  end
end
