class Company < ApplicationRecord

  has_many :branches, inverse_of: :company

  validates_presence_of   :company_name
  validates_uniqueness_of :company_name
  attr_accessor :save_branch_as_nested
  accepts_nested_attributes_for :branches
  validates_associated :branches, if: 'save_branch_as_nested.present?'
end