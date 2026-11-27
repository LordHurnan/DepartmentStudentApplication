require "test_helper"

class DepartmentsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @department = departments(:one)
  end

  # REGULAR USER TESTS

  test "regular user can view departments" do
    sign_in_as users(:one)

    get departments_url
    assert_response :success

    get department_url(@department)
    assert_response :success
  end

  test "regular user cannot access new department form" do
    sign_in_as users(:one)

    get new_department_url
    assert_redirected_to root_url
  end

  test "regular user cannot create a department" do
    sign_in_as users(:one)

    assert_no_difference("Department.count") do
      post departments_url, params: {
        department: {
          location: "Unauthorized Location",
          name: "Unauthorized Department"
        }
      }
    end

    assert_redirected_to root_url
  end

  test "regular user cannot access edit department form" do
    sign_in_as users(:one)

    get edit_department_url(@department)
    assert_redirected_to root_url
  end

  test "regular user cannot update a department" do
    sign_in_as users(:one)

    original_name = @department.name
    original_location = @department.location

    patch department_url(@department), params: {
      department: {
        name: "Unauthorized Update",
        location: "Unauthorized Location"
      }
    }

    assert_redirected_to root_url

    @department.reload
    assert_equal original_name, @department.name
    assert_equal original_location, @department.location
  end

  test "regular user cannot delete a department" do
    sign_in_as users(:one)

    assert_no_difference("Department.count") do
      delete department_url(@department)
    end

    assert_redirected_to root_url
  end

  # ADMIN TESTS

  test "admin can access new department form" do
    sign_in_as users(:admin)

    get new_department_url
    assert_response :success
  end

  test "admin can create a department" do
    sign_in_as users(:admin)

    assert_difference("Department.count", 1) do
      post departments_url, params: {
        department: {
          location: "Admin Location",
          name: "Admin Created Department"
        }
      }
    end

    assert_redirected_to department_url(Department.last)
  end

  test "admin can access edit department form" do
    sign_in_as users(:admin)

    get edit_department_url(@department)
    assert_response :success
  end

  test "admin can update a department" do
    sign_in_as users(:admin)

    patch department_url(@department), params: {
      department: {
        name: "Admin Updated Department",
        location: "Admin Updated Location"
      }
    }

    assert_redirected_to department_url(@department)

    @department.reload
    assert_equal "Admin Updated Department", @department.name
    assert_equal "Admin Updated Location", @department.location
  end

  test "admin can delete a department" do
    sign_in_as users(:admin)

    assert_difference("Department.count", -1) do
      delete department_url(@department)
    end

    assert_redirected_to departments_url
  end
end