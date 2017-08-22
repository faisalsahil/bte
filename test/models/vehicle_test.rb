require 'test_helper'

class VehicleTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end

# == Schema Information
#
# Table name: vehicles
#
#  id             :integer          not null, primary key
#  vehicle_type   :string
#  vehicle_number :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  is_deleted     :boolean          default(FALSE)
#
