class StorageType < ApplicationRecord
  validates_presence_of :name
end

# == Schema Information
#
# Table name: storage_types
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  is_deleted :boolean          default(FALSE)
#
