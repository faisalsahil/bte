class Route < ApplicationRecord
  belongs_to :state
  belongs_to :city

  has_many :route_branches, dependent: :destroy, inverse_of: :route
  has_many :branches,       through: :route_branches
  
  accepts_nested_attributes_for :route_branches
end
