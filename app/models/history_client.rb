class HistoryClient < ApplicationRecord
  belongs_to :email_history
  belongs_to :branch
end

# == Schema Information
#
# Table name: history_clients
#
#  id               :integer          not null, primary key
#  email_history_id :integer
#  branch_id        :integer
#  count            :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
