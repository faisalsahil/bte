class Vehicle < ApplicationRecord
  
  has_many :user_vehicles
  has_many :users, through: :user_vehicles
  has_many :schedule_branches
  
  validates_presence_of :vehicle_type, :vehicle_number
end

