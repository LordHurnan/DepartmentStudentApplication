require "test_helper"

class LaboratoriesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @laboratory = laboratories(:one)
  end

  # REGULAR USER TESTS

  test "regular user can view laboratories" do
    sign_in_as users(:one)

    get laboratories_url
    assert_response :success

    get laboratory_url(@laboratory)
    assert_response :success
  end

  test "regular user cannot access new laboratory form" do
    sign_in_as users(:one)

    get new_laboratory_url
    assert_redirected_to root_url
  end

  test "regular user cannot create a laboratory" do
    sign_in_as users(:one)

    assert_no_difference("Laboratory.count") do
      post laboratories_url, params: {
        laboratory: {
          department_id: @laboratory.department_id,
          location: "Unauthorized Location",
          name: "Unauthorized Laboratory"
        }
      }
    end

    assert_redirected_to root_url
  end

  test "regular user cannot access edit laboratory form" do
    sign_in_as users(:one)

    get edit_laboratory_url(@laboratory)
    assert_redirected_to root_url
  end

  test "regular user cannot update a laboratory" do
    sign_in_as users(:one)

    original_name = @laboratory.name
    original_location = @laboratory.location

    patch laboratory_url(@laboratory), params: {
      laboratory: {
        name: "Unauthorized Update",
        location: "Unauthorized Location"
      }
    }

    assert_redirected_to root_url

    @laboratory.reload
    assert_equal original_name, @laboratory.name
    assert_equal original_location, @laboratory.location
  end

  test "regular user cannot delete a laboratory" do
    sign_in_as users(:one)

    assert_no_difference("Laboratory.count") do
      delete laboratory_url(@laboratory)
    end

    assert_redirected_to root_url
  end

  # ADMIN TESTS

  test "admin can access new laboratory form" do
    sign_in_as users(:admin)

    get new_laboratory_url
    assert_response :success
  end

  test "admin can create a laboratory" do
    sign_in_as users(:admin)

    assert_difference("Laboratory.count", 1) do
      post laboratories_url, params: {
        laboratory: {
          department_id: @laboratory.department_id,
          location: "Admin Location",
          name: "Admin Created Laboratory"
        }
      }
    end

    assert_redirected_to laboratory_url(Laboratory.last)
  end

  test "admin can access edit laboratory form" do
    sign_in_as users(:admin)

    get edit_laboratory_url(@laboratory)
    assert_response :success
  end

  test "admin can update a laboratory" do
    sign_in_as users(:admin)

    patch laboratory_url(@laboratory), params: {
      laboratory: {
        name: "Admin Updated Laboratory",
        location: "Admin Updated Location"
      }
    }

    assert_redirected_to laboratory_url(@laboratory)

    @laboratory.reload
    assert_equal "Admin Updated Laboratory", @laboratory.name
    assert_equal "Admin Updated Location", @laboratory.location
  end

  test "admin can delete a laboratory" do
    sign_in_as users(:admin)

    assert_difference("Laboratory.count", -1) do
      delete laboratory_url(@laboratory)
    end

    assert_redirected_to laboratories_url
  end
end