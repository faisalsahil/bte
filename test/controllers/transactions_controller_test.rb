require 'test_helper'

class TransactionsControllerTest < ActionDispatch::IntegrationTest
  test "should get payment" do
    get transactions_payment_url
    assert_response :success
  end

end
