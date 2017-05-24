class Assignment < ApplicationRecord
  
  
  
  belongs_to :route
  belongs_to :driver, class_name:  :User, foreign_key: :driver_id
  belongs_to :helper, class_name:  :User, foreign_key: :helper_id
  belongs_to :vehicle

  
  validates_uniqueness_of :route_id, message: 'already assigned'
  validates_uniqueness_of :route_id, scope: :driver_id, message: 'driver already assigned'
  validates_uniqueness_of :route_id, scope: :helper_id, message: ' helper already assigned'
  validates_uniqueness_of :route_id, scope: :vehicle_id, message: 'vehicle already assigned'
end
