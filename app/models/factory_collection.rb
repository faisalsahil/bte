class FactoryCollection < ApplicationRecord
  has_many :route_branches
  
  accepts_nested_attributes_for :route_branches
end
