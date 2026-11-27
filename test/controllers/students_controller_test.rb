require "test_helper"

class StudentsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @student = students(:one)
  end

  # REGULAR USER TESTS

  test "regular user can view students" do
    sign_in_as users(:one)

    get students_url
    assert_response :success

    get student_url(@student)
    assert_response :success
  end

  test "regular user cannot access new student form" do
    sign_in_as users(:one)

    get new_student_url
    assert_redirected_to root_url
  end

  test "regular user cannot create a student" do
    sign_in_as users(:one)

    assert_no_difference("Student.count") do
      post students_url, params: {
        student: {
          department_id: @student.department_id,
          name: "Unauthorized Student",
          program: @student.program,
          year_level: @student.year_level
        }
      }
    end

    assert_redirected_to root_url
  end

  test "regular user cannot access edit student form" do
    sign_in_as users(:one)

    get edit_student_url(@student)
    assert_redirected_to root_url
  end

  test "regular user cannot update a student" do
    sign_in_as users(:one)

    original_name = @student.name

    patch student_url(@student), params: {
      student: { name: "Unauthorized Update" }
    }

    assert_redirected_to root_url
    assert_equal original_name, @student.reload.name
  end

  test "regular user cannot delete a student" do
    sign_in_as users(:one)

    assert_no_difference("Student.count") do
      delete student_url(@student)
    end

    assert_redirected_to root_url
  end

  test "regular user cannot access student import form" do
    sign_in_as users(:one)

    get import_students_url
    assert_redirected_to root_url
  end

  test "regular user cannot import students" do
    sign_in_as users(:one)

    assert_no_difference("Student.count") do
      post import_students_url
    end

    assert_redirected_to root_url
  end

  # ADMIN TESTS

  test "admin can access new student form" do
    sign_in_as users(:admin)

    get new_student_url
    assert_response :success
  end

  test "admin can access edit student form" do
    sign_in_as users(:admin)

    get edit_student_url(@student)
    assert_response :success
  end

  test "admin can create a student" do
    sign_in_as users(:admin)

    assert_difference("Student.count", 1) do
      post students_url, params: {
        student: {
          department_id: @student.department_id,
          name: "Admin Created Student",
          program: @student.program,
          year_level: @student.year_level
        }
      }
    end

    assert_redirected_to student_url(Student.last)
  end

  test "admin can update a student" do
    sign_in_as users(:admin)

    patch student_url(@student), params: {
      student: { name: "Admin Updated Student" }
    }

    @student.reload

    assert_redirected_to student_url(@student)
    assert_equal "Admin Updated Student", @student.name
  end

  test "admin can delete a student" do
    sign_in_as users(:admin)

    assert_difference("Student.count", -1) do
      delete student_url(@student)
    end

    assert_redirected_to students_url
  end
end