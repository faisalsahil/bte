class EmailHistory < ApplicationRecord
  has_many   :history_clients, dependent: :destroy
  belongs_to :template
end

# == Schema Information
#
# Table name: email_histories
#
#  id          :integer          not null, primary key
#  template_id :integer
#  html        :text
#  subject     :string
#  from_email  :string
#  cc          :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
