class Schedule < ApplicationRecord
  
  has_many :schedule_branches
  has_many :branches, through: :schedule_branches
end
