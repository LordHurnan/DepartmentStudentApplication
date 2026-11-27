require "test_helper"

class SectionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @section = sections(:one)
  end

  # REGULAR USER TESTS

  test "regular user can view sections" do
    sign_in_as users(:one)

    get sections_url
    assert_response :success

    get section_url(@section)
    assert_response :success
  end

  test "regular user cannot access new section form" do
    sign_in_as users(:one)

    get new_section_url
    assert_redirected_to root_url
  end

  test "regular user cannot create a section" do
    sign_in_as users(:one)

    assert_no_difference("Section.count") do
      post sections_url, params: {
        section: {
          name: "Unauthorized Section",
          room: "Unauthorized Room",
          timeslot: "Unauthorized Timeslot",
          subject_id: @section.subject_id
        }
      }
    end

    assert_redirected_to root_url
  end

  test "regular user cannot access edit section form" do
    sign_in_as users(:one)

    get edit_section_url(@section)
    assert_redirected_to root_url
  end

  test "regular user cannot update a section" do
    sign_in_as users(:one)

    original_name = @section.name
    original_room = @section.room
    original_timeslot = @section.timeslot

    patch section_url(@section), params: {
      section: {
        name: "Unauthorized Update",
        room: "Unauthorized Room",
        timeslot: "Unauthorized Timeslot"
      }
    }

    assert_redirected_to root_url

    @section.reload
    assert_equal original_name, @section.name
    assert_equal original_room, @section.room
    assert_equal original_timeslot, @section.timeslot
  end

  test "regular user cannot delete a section" do
    sign_in_as users(:one)

    assert_no_difference("Section.count") do
      delete section_url(@section)
    end

    assert_redirected_to root_url
  end

  # ADMIN TESTS

  test "admin can access new section form" do
    sign_in_as users(:admin)

    get new_section_url
    assert_response :success
  end

  test "admin can create a section" do
    sign_in_as users(:admin)

    assert_difference("Section.count", 1) do
      post sections_url, params: {
        section: {
          name: "Admin Created Section",
          room: "Admin Room",
          timeslot: "Admin Timeslot",
          subject_id: @section.subject_id
        }
      }
    end

    assert_redirected_to section_url(Section.last)
  end

  test "admin can access edit section form" do
    sign_in_as users(:admin)

    get edit_section_url(@section)
    assert_response :success
  end

  test "admin can update a section" do
    sign_in_as users(:admin)

    patch section_url(@section), params: {
      section: {
        name: "Admin Updated Section",
        room: "Admin Updated Room",
        timeslot: "Admin Updated Timeslot"
      }
    }

    assert_redirected_to section_url(@section)

    @section.reload
    assert_equal "Admin Updated Section", @section.name
    assert_equal "Admin Updated Room", @section.room
    assert_equal "Admin Updated Timeslot", @section.timeslot
  end

  test "admin can delete a section" do
    sign_in_as users(:admin)

    assert_difference("Section.count", -1) do
      delete section_url(@section)
    end

    assert_redirected_to sections_url
  end
end