require 'test_helper'

class CreateArticlesTest < ActionDispatch::IntegrationTest
  
  def setup
    @user = User.create(username:"kai32", email: "kaixiang@example.com", password: "password", admin: false)
    @category = Category.create(name: "cat1")
    @category2 = Category.create(name: "cat2")
    @category3 = Category.create(name: "cat3")
    
  end
  
  test 'get new article form and create article' do
    sign_in_as(@user, "password")
    get new_article_path
    assert_template 'articles/new'
    assert_difference 'Article.count', 1 do
      post_via_redirect articles_path, article: {title: "test article", description: "this is a test", category_ids: [1,2,3]}
    end
    assert_template 'articles/show'
    assert_match 'test article', response.body
    assert_match 'cat1', response.body
    assert_match 'cat2', response.body
    assert_match 'cat3', response.body
    
  end
  
  test 'invalid article submission results in failure' do
    sign_in_as(@user, "password")
    get new_article_path
    assert_template 'articles/new'
    assert_no_difference 'Article.count' do
      post articles_path, article: {title: " ", description: "this is a test", category_ids: [1,2,3]}
    end
    assert_template 'articles/new'
    assert_select 'h2.panel-title'
    assert_select 'div.panel-body'
  end
end