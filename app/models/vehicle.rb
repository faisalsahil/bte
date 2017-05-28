class Vehicle < ApplicationRecord
  validates_presence_of :vehicle_type, :vehicle_number
end

