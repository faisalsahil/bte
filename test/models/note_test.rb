require 'test_helper'

class NoteTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end

# == Schema Information
#
# Table name: notes
#
#  id              :integer          not null, primary key
#  branch_id       :integer
#  comment         :text
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  completed_notes :text
#  is_completed    :boolean
#
