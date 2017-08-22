class City < ApplicationRecord
  belongs_to :state
  has_many   :areas
end

# == Schema Information
#
# Table name: cities
#
#  id         :integer          not null, primary key
#  state_id   :integer
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  is_deleted :boolean          default(FALSE)
#
