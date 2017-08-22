class Assignment < ApplicationRecord
  
  belongs_to :route
  belongs_to :driver, class_name:  :User, foreign_key: :driver_id, optional: true
  belongs_to :helper, class_name:  :User, foreign_key: :helper_id, optional: true
  belongs_to :vehicle, optional: true

  
  validates_uniqueness_of :route_id, message: 'already assigned'
  validates_uniqueness_of :route_id, scope: :driver_id, message: 'driver already assigned'
  validates_uniqueness_of :route_id, scope: :helper_id, message: ' helper already assigned'
  validates_uniqueness_of :route_id, scope: :vehicle_id, message: 'vehicle already assigned'
end

# == Schema Information
#
# Table name: assignments
#
#  id                :integer          not null, primary key
#  assigned_at       :date
#  driver_id         :integer
#  helper_id         :integer
#  vehicle_id        :integer
#  route_id          :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  is_completed      :boolean          default(FALSE)
#  assignment_status :string           default("active")
#  is_deleted        :boolean          default(FALSE)
#
