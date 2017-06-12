class RouteBranch < ApplicationRecord
  
  belongs_to :route, inverse_of: :route_branches
  belongs_to :branch
  belongs_to :factory_collection, optional: true
  mount_uploader :image,  ImageUploader
  mount_uploader :factory_image,  ImageUploader
end
