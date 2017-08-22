require 'test_helper'

class HistoryClientTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end

# == Schema Information
#
# Table name: history_clients
#
#  id               :integer          not null, primary key
#  email_history_id :integer
#  branch_id        :integer
#  count            :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
