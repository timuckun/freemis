require File.dirname(__FILE__) + '/../test_helper'
require 'spell_controller'
include AuthenticatedTestHelper

# Re-raise errors caught by the controller.
class SpellController; def rescue_action(e) raise e end; end

class SpellControllerTest < Test::Unit::TestCase
  fixtures :users, :school_sessions
  def setup
    @controller = SpellController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    login_as("teacheruser")
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
