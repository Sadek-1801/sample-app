require "test_helper"

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  def setup
    @user = User.new(name: "example user", email: "example@mail.com", password: "foobar", password_confirmation: "foobar")
  end

  test "should be valid" do
    assert @user.valid?
  end

  test "name should be present" do
    @user.name = "  "
    assert_not @user.valid?
  end

  test "email should be present" do
    @user.email = "  "
    assert_not @user.valid?
  end

  test "name should not be too long" do
    @user.name = "a" * 51
    assert_not @user.valid?
  end

  #email related tests

  test "email should not be too long" do
    @user.email = "a" * 244 + "@example.com"
    assert_not @user.valid?
  end

  test "email validation should accept valid addresses" do
    valid_address = %w[user@example.com USER@foo.COM A_US_ER@foo.bar.org first.last@foo.jp alice+bob@baz.cn]
    valid_address.each do |v|
      @user.email = v
      assert @user.valid?, "#{v.inspect} should be valid"
    end
  end

  test "email validation should reject invalid addresses" do
    invalid_addresses = %w[user@example,com user_at_foo.org user.name@example foo@bar_baz.com foo@bar+baz.com]
    invalid_addresses.each do |invalid_add|
      @user.email = invalid_add
      assert_not @user.valid?, "#{invalid_add.inspect} should be invalid"
    end
  end

  test "email addresses should be unique" do
    duplicate_user = @user.dup
    @user.save
    assert_not duplicate_user.valid?
  end

  test "email addresses should be saved as lowercase" do
    mixed_case_email = "Foo@ExAMPle.CoM"
    @user.email = mixed_case_email
    @user.save
    assert_equal mixed_case_email.downcase, @user.reload.email
  end

  # password related tests

  test "pasword should be presen" do
    @user.password = @user.password_confirmation = " " * 6
    assert_not @user.valid?
  end

  test "pasword should have a minimum length" do
    @user.password = @user.password_confirmation = "a" * 5
    assert_not @user.valid?
  end

  test "authenticated? should return false for a user with nil digest" do
    assert_not @user.authenticated?(:remember, '')
  end

  test "associated microposts should be destroyed" do
    @user.save
    @user.microposts.create!(content: "Lorem ipsum")
    assert_difference 'Micropost.count', -1 do
      @user.destroy
    end
  end

  test "should follow and unfollow a user" do
    first_user = users(:one)
    second_user = users(:four)
    assert_not first_user.following?(second_user)
    first_user.follow(second_user)
    assert first_user.following?(second_user)
    assert second_user.followers.include?(first_user)
    first_user.unfollow(second_user)
    assert_not first_user.following?(second_user)
    # User can't follow themselves
    first_user.follow(first_user)
    assert_not first_user.following?(first_user)
  end

  test "feed should  have the right posts" do
    user1 = users(:one)
    user2 = users(:two)
    user3 = users(:three)
    # Post from  followed user
    user1.microposts.each do |post_followed|
      assert user2.feed.include?(post_followed)
    end
    # Self-posts for user with followers
    user1.microposts.each do |post_self|
      assert user1.feed.include?(post_self)
    end
    # Posts from non-followed user
    user3.microposts.each do |post_unfollowed|
      assert_not user2.feed.include?(post_unfollowed)
    end
  end
end
