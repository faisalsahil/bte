require 'test_helper'

class CompanyTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
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
