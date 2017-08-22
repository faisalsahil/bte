class Billing < ApplicationRecord
  
  has_many   :transactions
  belongs_to :branch
end

# == Schema Information
#
# Table name: billings
#
#  id         :integer          not null, primary key
#  branch_id  :integer
#  total      :float
#  paid       :float
#  balance    :float
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
