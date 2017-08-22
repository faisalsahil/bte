require 'test_helper'

class RouteTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end

# == Schema Information
#
# Table name: routes
#
#  id           :integer          not null, primary key
#  state_id     :integer
#  city_id      :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  is_completed :boolean          default(FALSE)
#  areas        :text             default([]), is an Array
#  is_deleted   :boolean          default(FALSE)
#
