class Transaction < ApplicationRecord
  belongs_to :branch

  attr_accessor :balance
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
