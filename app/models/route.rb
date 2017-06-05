class Route < ApplicationRecord
  belongs_to :state
  belongs_to :city

  has_many :route_branches, dependent: :destroy, inverse_of: :route
  has_many :branches,       through: :route_branches
  has_one  :assignment, dependent: :destroy
  scope :active_routes, -> { where(is_completed: false) }
  
  accepts_nested_attributes_for :route_branches

  serialize :area_ids, Array

end
