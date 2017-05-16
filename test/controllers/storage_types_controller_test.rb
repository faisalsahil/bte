require 'test_helper'

class StorageTypesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @storage_type = storage_types(:one)
  end

  test "should get index" do
    get storage_types_url
    assert_response :success
  end

  test "should get new" do
    get new_storage_type_url
    assert_response :success
  end

  test "should create storage_type" do
    assert_difference('StorageType.count') do
      post storage_types_url, params: { storage_type: { name: @storage_type.name } }
    end

    assert_redirected_to storage_type_url(StorageType.last)
  end

  test "should show storage_type" do
    get storage_type_url(@storage_type)
    assert_response :success
  end

  test "should get edit" do
    get edit_storage_type_url(@storage_type)
    assert_response :success
  end

  test "should update storage_type" do
    patch storage_type_url(@storage_type), params: { storage_type: { name: @storage_type.name } }
    assert_redirected_to storage_type_url(@storage_type)
  end

  test "should destroy storage_type" do
    assert_difference('StorageType.count', -1) do
      delete storage_type_url(@storage_type)
    end

    assert_redirected_to storage_types_url
  end
end
