require File.dirname(__FILE__) + '/../../test_helper'
require 'admin/vote_controller'

# Re-raise errors caught by the controller.
class Admin::VoteController; def rescue_action(e) raise e end; end

class Admin::VoteControllerTest < Test::Unit::TestCase
  fixtures :votes

  def setup
    @controller = Admin::VoteController.new
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

    assert_not_nil assigns(:votes)
  end

  def test_show
    get :show, :id => 1

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:vote)
    assert assigns(:vote).valid?
  end

  def test_new
    get :new

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:vote)
  end

  def test_create
    num_votes = Vote.count

    post :create, :vote => {}

    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_equal num_votes + 1, Vote.count
  end

  def test_edit
    get :edit, :id => 1

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:vote)
    assert assigns(:vote).valid?
  end

  def test_update
    post :update, :id => 1
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => 1
  end

  def test_destroy
    assert_not_nil Vote.find(1)

    post :destroy, :id => 1
    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      Vote.find(1)
    }
  end
end
