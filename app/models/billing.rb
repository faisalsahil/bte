class Billing < ApplicationRecord
  
  has_many   :transactions
  belongs_to :branch
end
