require 'test_helper'

class HistoryClientsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @history_client = history_clients(:one)
  end

  test "should get index" do
    get history_clients_url
    assert_response :success
  end

  test "should get new" do
    get new_history_client_url
    assert_response :success
  end

  test "should create history_client" do
    assert_difference('HistoryClient.count') do
      post history_clients_url, params: { history_client: { client_id: @history_client.client_id, count: @history_client.count, email_history_id: @history_client.email_history_id } }
    end

    assert_redirected_to history_client_url(HistoryClient.last)
  end

  test "should show history_client" do
    get history_client_url(@history_client)
    assert_response :success
  end

  test "should get edit" do
    get edit_history_client_url(@history_client)
    assert_response :success
  end

  test "should update history_client" do
    patch history_client_url(@history_client), params: { history_client: { client_id: @history_client.client_id, count: @history_client.count, email_history_id: @history_client.email_history_id } }
    assert_redirected_to history_client_url(@history_client)
  end

  test "should destroy history_client" do
    assert_difference('HistoryClient.count', -1) do
      delete history_client_url(@history_client)
    end

    assert_redirected_to history_clients_url
  end
end
