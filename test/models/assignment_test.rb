require 'test_helper'

class AssignmentTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end

# == Schema Information
#
# Table name: assignments
#
#  id                :integer          not null, primary key
#  assigned_at       :date
#  driver_id         :integer
#  helper_id         :integer
#  vehicle_id        :integer
#  route_id          :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  is_completed      :boolean          default(FALSE)
#  assignment_status :string           default("active")
#  is_deleted        :boolean          default(FALSE)
#
