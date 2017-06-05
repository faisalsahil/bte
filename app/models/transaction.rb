class Transaction < ApplicationRecord
  belongs_to :branch

  attr_accessor :balance
end
