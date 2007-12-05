require File.dirname(__FILE__) + '/../../test_helper'
require 'admin/comment_controller'

# Re-raise errors caught by the controller.
class Admin::CommentController; def rescue_action(e) raise e end; end

class Admin::CommentControllerTest < Test::Unit::TestCase
  fixtures :news_comments

  def setup
    @controller = Admin::CommentController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_index
    get :index
    assert_response :success
    assert_template 'list'
  end

  def test_list
    get :list

    assert_response :success
    assert_template 'list'

    assert_not_nil assigns(:news_comments)
  end

  def test_show
    get :show, :id => 1

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:news_comment)
    assert assigns(:news_comment).valid?
  end

  def test_new
    get :new

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:news_comment)
  end

  def test_create
    num_news_comments = NewsComment.count

    post :create, :news_comment => {}

    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_equal num_news_comments + 1, NewsComment.count
  end

  def test_edit
    get :edit, :id => 1

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:news_comment)
    assert assigns(:news_comment).valid?
  end

  def test_update
    post :update, :id => 1
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => 1
  end

  def test_destroy
    assert_not_nil NewsComment.find(1)

    post :destroy, :id => 1
    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      NewsComment.find(1)
    }
  end
end
