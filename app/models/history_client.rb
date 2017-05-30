class HistoryClient < ApplicationRecord
  belongs_to :email_history
  belongs_to :branch
end
