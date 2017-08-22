require 'test_helper'

class TemplateTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end

# == Schema Information
#
# Table name: templates
#
#  id         :integer          not null, primary key
#  html       :text
#  subject    :string
#  from_email :string
#  cc         :string
#  is_deleted :boolean          default(FALSE)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
