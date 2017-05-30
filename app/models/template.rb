class Template < ApplicationRecord
  has_many :email_histories, dependent: :destroy
end
