class FactoryCollection < ApplicationRecord
  has_many :route_branches
  
  accepts_nested_attributes_for :route_branches
end

# == Schema Information
#
# Table name: factory_collections
#
#  id         :integer          not null, primary key
#  date       :date
#  quantity   :float
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
