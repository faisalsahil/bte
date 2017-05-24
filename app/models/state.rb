class State < ApplicationRecord
  has_many :cities
  has_many :areas
end
