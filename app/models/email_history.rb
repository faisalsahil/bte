class EmailHistory < ApplicationRecord
  has_many   :history_clients, dependent: :destroy
  belongs_to :template
end
