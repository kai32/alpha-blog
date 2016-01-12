require 'test_helper'

class CreateUsersTest < ActionDispatch::IntegrationTest
  
  test 'get new user form and create user' do
    get signup_path
    assert_template 'users/new'
    assert_difference 'User.count', 1 do
      post_via_redirect users_path, user: {username: "test_user", email: "test@tester.com", password: "password"}
    end
    assert_template 'users/show'
    assert_match 'test_user', response.body
  end
  
  test 'invalid user submission results in failure' do
    get signup_path
    assert_template 'users/new'
    assert_no_difference 'User.count' do
      post users_path, user: {username: "test_user", email: " ", password: "password"}
    end
    assert_template 'users/new'
    assert_select 'h2.panel-title'
    assert_select 'div.panel-body'
  end
end