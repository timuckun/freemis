require File.dirname(__FILE__) + '/../test_helper'
require 'timetable_days_controller'

# Re-raise errors caught by the controller.
class TimetableDaysController; def rescue_action(e) raise e end; end

class TimetableDaysControllerTest < Test::Unit::TestCase
  fixtures :timetable_days

  def setup
    @controller = TimetableDaysController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

 def test_nothing
  assert true
 end
end
