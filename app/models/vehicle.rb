class Vehicle < ApplicationRecord
  
  has_many :user_vehicles
  has_many :users, through: :user_vehicles
end
