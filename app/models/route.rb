class Route < ApplicationRecord
  belongs_to :state, optional: true
  belongs_to :city, optional: true
  
  has_many :route_branches, dependent: :destroy, inverse_of: :route
  has_many :branches, through: :route_branches
  has_one :assignment, dependent: :destroy
  scope :active_routes, -> { where(is_completed: false) }
  
  accepts_nested_attributes_for :route_branches
  
  serialize :area_ids, Array

end

# == Schema Information
#
# Table name: routes
#
#  id           :integer          not null, primary key
#  state_id     :integer
#  city_id      :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  is_completed :boolean          default(FALSE)
#  areas        :text             default([]), is an Array
#  is_deleted   :boolean          default(FALSE)
#
