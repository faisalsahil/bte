require 'test_helper'

class TransactionTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end

# == Schema Information
#
# Table name: transactions
#
#  id               :integer          not null, primary key
#  amount           :float
#  transaction_date :date
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  branch_id        :integer
#
