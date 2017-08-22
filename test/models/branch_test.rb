require 'test_helper'

class BranchTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end

# == Schema Information
#
# Table name: branches
#
#  id                :integer          not null, primary key
#  company_id        :integer
#  branch_name       :string
#  contact_name      :string
#  contact_email     :string
#  contact_phone     :string
#  number_of_outlets :integer
#  monthly_oil_used  :float
#  latitude          :float
#  longitude         :float
#  address           :text
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  street            :string
#  zip               :string
#  area_id           :integer
#  storage_type_id   :integer
#  food_type_id      :integer
#  city_id           :integer
#  state_id          :integer
#  rate_per_kg       :float
#  branch_status     :string
#  representative    :integer
#  visits_per_month  :integer
#  branch_code       :integer          default(0)
#  is_deleted        :boolean          default(FALSE)
#  contact_name1     :string
#  contact_email1    :string
#  contact_phone1    :string
#
