class Company < ApplicationRecord

  has_many :branches, inverse_of: :company

  validates_presence_of   :company_name
  validates_uniqueness_of :company_name, scope: :site_id
  attr_accessor :save_branch_as_nested
  accepts_nested_attributes_for :branches
  validates_associated :branches, if: 'save_branch_as_nested.present?'
end

# == Schema Information
#
# Table name: companies
#
#  id                :integer          not null, primary key
#  company_name      :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  contact_name      :string
#  contact_email     :string
#  contact_phone     :string
#  company_status    :string           default("visit")
#  number_of_outlets :integer
#  company_code      :integer          default(0)
#  is_deleted        :boolean          default(FALSE)
#
