require File.dirname(__FILE__) + '/../test_helper'
require 'competition_controller'

# Re-raise errors caught by the controller.
class CompetitionController; def rescue_action(e) raise e end; end

class CompetitionControllerTest < Test::Unit::TestCase
  def setup
    @controller = CompetitionController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
