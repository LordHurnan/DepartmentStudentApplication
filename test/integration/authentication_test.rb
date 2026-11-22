require "test_helper"

class AuthenticationTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
  end

  test "login page is reachable without logging in" do
    get new_session_url
    assert_response :success
  end

  test "visitors are redirected to login for every protected page" do
    [
      root_url, students_url, new_student_url, import_students_url,
      teachers_url, subjects_url, departments_url,
      sections_url, laboratories_url, classlists_url
    ].each do |url|
      get url
      assert_redirected_to new_session_url, "#{url} should require login"
    end
  end

  test "visitors cannot delete records by sending the request directly" do
    assert_no_difference("Student.count") do
      delete student_url(students(:one))
    end
    assert_redirected_to new_session_url
  end

  test "user can log in with correct credentials" do
    post session_url, params: { email_address: @user.email_address, password: "password" }
    assert_redirected_to root_url

    get students_url
    assert_response :success
  end

  test "wrong password is rejected" do
    post session_url, params: { email_address: @user.email_address, password: "wrong" }
    assert_redirected_to new_session_url

    get students_url
    assert_redirected_to new_session_url
  end

  test "unknown email is rejected" do
    post session_url, params: { email_address: "nobody@example.com", password: "password" }
    assert_redirected_to new_session_url
  end

  test "user can log out and then loses access" do
    sign_in_as @user
    get students_url
    assert_response :success

    delete session_url
    assert_redirected_to new_session_url

    get students_url
    assert_redirected_to new_session_url
  end

  test "passwords are stored as bcrypt hashes, not plain text" do
    assert_not_equal "password", @user.password_digest
    assert @user.password_digest.start_with?("$2"), "digest should be a bcrypt hash"
  end
end
