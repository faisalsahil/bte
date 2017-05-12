class Branch < ApplicationRecord
  
  geocoded_by :address
  after_validation :geocode
  
  reverse_geocoded_by :latitude, :longitude
  after_validation :reverse_geocode

  has_many :schedule_branches
  belongs_to :area

  def address
    [street, city, state, zip].compact.join(', ')
  end
end
