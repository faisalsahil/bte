require 'test_helper'

class EmailHistoryTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
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
