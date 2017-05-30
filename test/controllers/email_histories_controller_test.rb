require 'test_helper'

class EmailHistoriesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @email_history = email_histories(:one)
  end

  test "should get index" do
    get email_histories_url
    assert_response :success
  end

  test "should get new" do
    get new_email_history_url
    assert_response :success
  end

  test "should create email_history" do
    assert_difference('EmailHistory.count') do
      post email_histories_url, params: { email_history: { cc: @email_history.cc, from_email: @email_history.from_email, html: @email_history.html, subject: @email_history.subject, template_id: @email_history.template_id } }
    end

    assert_redirected_to email_history_url(EmailHistory.last)
  end

  test "should show email_history" do
    get email_history_url(@email_history)
    assert_response :success
  end

  test "should get edit" do
    get edit_email_history_url(@email_history)
    assert_response :success
  end

  test "should update email_history" do
    patch email_history_url(@email_history), params: { email_history: { cc: @email_history.cc, from_email: @email_history.from_email, html: @email_history.html, subject: @email_history.subject, template_id: @email_history.template_id } }
    assert_redirected_to email_history_url(@email_history)
  end

  test "should destroy email_history" do
    assert_difference('EmailHistory.count', -1) do
      delete email_history_url(@email_history)
    end

    assert_redirected_to email_histories_url
  end
end
