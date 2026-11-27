require "test_helper"

class ClasslistsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @classlist = classlists(:one)
  end

  # REGULAR USER TESTS

  test "regular user can view class lists" do
    sign_in_as users(:one)

    get classlists_url
    assert_response :success

    get classlist_url(@classlist)
    assert_response :success
  end

  test "regular user cannot access new class list form" do
    sign_in_as users(:one)

    get new_classlist_url
    assert_redirected_to root_url
  end

  test "regular user cannot create a class list" do
    sign_in_as users(:one)

    assert_no_difference("Classlist.count") do
      post classlists_url, params: {
        classlist: {
          student_id: @classlist.student_id,
          section_id: @classlist.section_id
        }
      }
    end

    assert_redirected_to root_url
  end

  test "regular user cannot access edit class list form" do
    sign_in_as users(:one)

    get edit_classlist_url(@classlist)
    assert_redirected_to root_url
  end

  test "regular user cannot update a class list" do
    sign_in_as users(:one)

    original_student_id = @classlist.student_id
    original_section_id = @classlist.section_id

    patch classlist_url(@classlist), params: {
      classlist: {
        student_id: original_student_id,
        section_id: original_section_id
      }
    }

    assert_redirected_to root_url

    @classlist.reload
    assert_equal original_student_id, @classlist.student_id
    assert_equal original_section_id, @classlist.section_id
  end

  test "regular user cannot delete a class list" do
    sign_in_as users(:one)

    assert_no_difference("Classlist.count") do
      delete classlist_url(@classlist)
    end

    assert_redirected_to root_url
  end

  # ADMIN TESTS

  test "admin can access new class list form" do
    sign_in_as users(:admin)

    get new_classlist_url
    assert_response :success
  end

  test "admin can create a class list" do
    sign_in_as users(:admin)

    assert_difference("Classlist.count", 1) do
      post classlists_url, params: {
        classlist: {
          student_id: students(:one).id,
          section_id: sections(:two).id
        }
      }
    end

    assert_redirected_to classlist_url(Classlist.last)
  end

  test "admin can access edit class list form" do
    sign_in_as users(:admin)

    get edit_classlist_url(@classlist)
    assert_response :success
  end

  test "admin can update a class list" do
    sign_in_as users(:admin)

    patch classlist_url(@classlist), params: {
      classlist: {
        student_id: @classlist.student_id,
        section_id: @classlist.section_id
      }
    }

    assert_redirected_to classlist_url(@classlist)
  end

  test "admin can delete a class list" do
    sign_in_as users(:admin)

    assert_difference("Classlist.count", -1) do
      delete classlist_url(@classlist)
    end

    assert_redirected_to classlists_url
  end
end