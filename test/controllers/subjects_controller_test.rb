require "test_helper"

class SubjectsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @subject = subjects(:one)
  end

  # REGULAR USER TESTS

  test "regular user can view subjects" do
    sign_in_as users(:one)

    get subjects_url
    assert_response :success

    get subject_url(@subject)
    assert_response :success
  end

  test "regular user cannot access new subject form" do
    sign_in_as users(:one)

    get new_subject_url
    assert_redirected_to root_url
  end

  test "regular user cannot create a subject" do
    sign_in_as users(:one)

    assert_no_difference("Subject.count") do
      post subjects_url, params: {
        subject: {
          name: "Unauthorized Subject",
          teacher_id: @subject.teacher_id,
          per_unit_rate: 500
        }
      }
    end

    assert_redirected_to root_url
  end

  test "regular user cannot access edit subject form" do
    sign_in_as users(:one)

    get edit_subject_url(@subject)
    assert_redirected_to root_url
  end

  test "regular user cannot update a subject" do
    sign_in_as users(:one)

    original_name = @subject.name
    original_rate = @subject.per_unit_rate

    patch subject_url(@subject), params: {
      subject: {
        name: "Unauthorized Update",
        per_unit_rate: 999
      }
    }

    assert_redirected_to root_url

    @subject.reload
    assert_equal original_name, @subject.name
    assert_equal original_rate, @subject.per_unit_rate
  end

  test "regular user cannot delete a subject" do
    sign_in_as users(:one)

    assert_no_difference("Subject.count") do
      delete subject_url(@subject)
    end

    assert_redirected_to root_url
  end

  # ADMIN TESTS

  test "admin can access new subject form" do
    sign_in_as users(:admin)

    get new_subject_url
    assert_response :success
  end

  test "admin can create a subject" do
    sign_in_as users(:admin)

    assert_difference("Subject.count", 1) do
      post subjects_url, params: {
        subject: {
          name: "Admin Created Subject",
          teacher_id: @subject.teacher_id,
          per_unit_rate: 500
        }
      }
    end

    assert_redirected_to subject_url(Subject.last)
  end

  test "admin can access edit subject form" do
    sign_in_as users(:admin)

    get edit_subject_url(@subject)
    assert_response :success
  end

  test "admin can update a subject" do
    sign_in_as users(:admin)

    patch subject_url(@subject), params: {
      subject: {
        name: "Admin Updated Subject",
        per_unit_rate: 750
      }
    }

    @subject.reload

    assert_redirected_to subject_url(@subject)
    assert_equal "Admin Updated Subject", @subject.name
    assert_equal 750, @subject.per_unit_rate
  end

  test "admin can delete a subject" do
    sign_in_as users(:admin)

    assert_difference("Subject.count", -1) do
      delete subject_url(@subject)
    end

    assert_redirected_to subjects_url
  end
end