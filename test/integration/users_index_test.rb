require "test_helper"

class UsersIndex < ActionDispatch::IntegrationTest

  def setup
    @admin = users(:one)
    @non_admin = users(:two)
  end
end

class UserIndexAdmin < UsersIndex

  def setup
    super
    log_in_as(@admin)
    get users_path
  end
end

class UsersIndexAdminTest < UserIndexAdmin

  test "should render the index page" do
    assert_template 'users/index'
  end

  test "should paginate users" do
    assert_select 'div.pagination', count: 1
  end

  test "should have delete links" do
    first_page_of_users = User.paginate(page: 1)
    first_page_of_users.each do |user|
      if user.activated?
        assert_select 'a[href=?]', user_path(user), text: user.name
        unless user == @admin
          assert_select 'a[href=?]', user_path(user), text: 'delete'
          end
      else
        assert_select 'a[href=?]', user_path(user), text: user.name, count: 0
      end
    end
  end

  test "should be able to delete a non admin user" do
    assert_difference 'User.count', -1 do
      delete user_path(@non_admin)
    end
    assert_response :see_other
    assert_redirected_to users_url
  end

  test "should display only activated users" do
    # Need to complete this test
    User.paginate(page: 1).first.toggle!(:activated)
    assigns(:users).each do |user|
      assert user.activated?
    end
  end
end

class UsersNonAdminIndexTest < UsersIndex
  test "should not have delete links as non_admin" do
    log_in_as(@non_admin)
    get users_path
    assert_select 'a', text: 'delete', count: 0
  end
end

