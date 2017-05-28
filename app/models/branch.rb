class Branch < ApplicationRecord
  
  validates_presence_of :rate_per_kg, :branch_code, :contact_phone
  
  geocoded_by :address
  after_validation :geocode
  
  reverse_geocoded_by :latitude, :longitude
  after_validation :reverse_geocode
  
  has_many :route_branches
  has_many :routes, through: :route_branches
  belongs_to :area
  belongs_to :storage_type
  belongs_to :food_type
  belongs_to :state
  belongs_to :city

  def address
    [street, city.name, state.name, zip].compact.join(', ')
  end
end
