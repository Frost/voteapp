require File.dirname(__FILE__) + '/../test_helper'
require 'rules_controller'

# Re-raise errors caught by the controller.
class RulesController; def rescue_action(e) raise e end; end

class RulesControllerTest < Test::Unit::TestCase
  def setup
    @controller = RulesController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
