require "test_helper"

class UserShowTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end

  def setup
    @inactive_user = users(:inactive)
    @activated_user = users(:two)
  end

  test "should redirect when user not activated" do
    get user_path(@inactive_user)
    # Need clarification
    assert_response :found
    assert_redirected_to root_url
  end

  test "should display user when activated" do
    get user_path(@activated_user)
    assert_response :success
    assert_template 'users/show'
  end

end
