require "test_helper"

class TeachersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @teacher = teachers(:one)
  end

  # REGULAR USER TESTS

  test "regular user can view teachers" do
    sign_in_as users(:one)

    get teachers_url
    assert_response :success

    get teacher_url(@teacher)
    assert_response :success
  end

  test "regular user cannot access new teacher form" do
    sign_in_as users(:one)

    get new_teacher_url
    assert_redirected_to root_url
  end

  test "regular user cannot create a teacher" do
    sign_in_as users(:one)

    assert_no_difference("Teacher.count") do
      post teachers_url, params: {
        teacher: {
          department_id: @teacher.department_id,
          email: "unauthorized@example.com",
          name: "Unauthorized Teacher",
          specialization: @teacher.specialization,
          per_unit_rate: 500
        }
      }
    end

    assert_redirected_to root_url
  end

  test "regular user cannot access edit teacher form" do
    sign_in_as users(:one)

    get edit_teacher_url(@teacher)
    assert_redirected_to root_url
  end

  test "regular user cannot update a teacher" do
    sign_in_as users(:one)

    original_name = @teacher.name

    patch teacher_url(@teacher), params: {
      teacher: { name: "Unauthorized Update" }
    }

    assert_redirected_to root_url
    assert_equal original_name, @teacher.reload.name
  end

  test "regular user cannot delete a teacher" do
    sign_in_as users(:one)

    assert_no_difference("Teacher.count") do
      delete teacher_url(@teacher)
    end

    assert_redirected_to root_url
  end

  # ADMIN TESTS

  test "admin can access new teacher form" do
    sign_in_as users(:admin)

    get new_teacher_url
    assert_response :success
  end

  test "admin can create a teacher" do
    sign_in_as users(:admin)

    assert_difference("Teacher.count", 1) do
      post teachers_url, params: {
        teacher: {
          department_id: @teacher.department_id,
          email: "admincreated@example.com",
          name: "Admin Created Teacher",
          specialization: @teacher.specialization,
          per_unit_rate: 500
        }
      }
    end

    assert_redirected_to teacher_url(Teacher.last)
  end

  test "admin can access edit teacher form" do
    sign_in_as users(:admin)

    get edit_teacher_url(@teacher)
    assert_response :success
  end

  test "admin can update a teacher" do
    sign_in_as users(:admin)

    patch teacher_url(@teacher), params: {
      teacher: { name: "Admin Updated Teacher" }
    }

    @teacher.reload

    assert_redirected_to teacher_url(@teacher)
    assert_equal "Admin Updated Teacher", @teacher.name
  end

  test "admin can delete a teacher" do
    sign_in_as users(:admin)

    assert_difference("Teacher.count", -1) do
      delete teacher_url(@teacher)
    end

    assert_redirected_to teachers_url
  end
end