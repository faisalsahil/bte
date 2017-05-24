class Area < ApplicationRecord
  has_many :branches
  belongs_to :state
  belongs_to :city

  validates_uniqueness_of :name, :scope => :city_id
  validates_presence_of   :name
end
