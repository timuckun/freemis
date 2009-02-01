require File.dirname(__FILE__) + '/../test_helper'
require 'faculties_controller'

# Re-raise errors caught by the controller.
class FacultiesController; def rescue_action(e) raise e end; end

class FacultiesControllerTest < Test::Unit::TestCase
  fixtures :faculties

  def setup
    @controller = FacultiesController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_nothing
    assert true
  end
end
