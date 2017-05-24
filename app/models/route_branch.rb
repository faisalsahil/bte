class RouteBranch < ApplicationRecord
  
  belongs_to :route, inverse_of: :route_branches
  belongs_to :branch
  
  mount_uploader :image, ImageUploader
end
