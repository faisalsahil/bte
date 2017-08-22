class Vehicle < ApplicationRecord
  validates_presence_of :vehicle_type, :vehicle_number



  def self.to_csv(truck_report_data)
    columns = ['vehicle', 'vehicle#', 'Tot Oil Collected', 'Tot Restaurant visit']
    CSV.generate do |csv|
      csv << columns
      truck_report_data&.each do |truck_data|
        ar = []
        ar << truck_data[:vehicle].vehicle_type
        ar << truck_data[:vehicle].vehicle_number
        ar << truck_data[:total_oil_collected]
        ar << truck_data[:total_branches_visited]
        csv << ar
      end
    end
  end
end

# == Schema Information
#
# Table name: vehicles
#
#  id             :integer          not null, primary key
#  vehicle_type   :string
#  vehicle_number :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  is_deleted     :boolean          default(FALSE)
#
