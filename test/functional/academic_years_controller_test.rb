require File.dirname(__FILE__) + '/../test_helper'
require 'academic_years_controller'
include AuthenticatedTestHelper
# Re-raise errors caught by the controller.
class AcademicYearsController; def rescue_action(e) raise e end; end

class AcademicYearsControllerTest < Test::Unit::TestCase
  fixtures :academic_years, :users, :groups

  def setup
    @controller = AcademicYearsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    login_as("teacheruser")
  end

  def test_index
    get :index
    assert_rendered_file 'list'
  end

  def test_list
    get :list
    assert_rendered_file 'list'
    assert_template_has 'academic_years'
  end

  def test_show
    get :show, 'id' => 2
    assert_rendered_file 'show'
    assert_template_has 'academic_year'
    assert_valid_record 'academic_year'
  end

  def test_new
    get :new
    assert_rendered_file 'new'
    assert_template_has 'academic_year'
  end

  def test_create
    num_academic_years = AcademicYear.find_all.size

    post :create, 'academic_year' => {"name"=>"09/10" }
    assert_redirected_to :action => 'list'

    assert_equal num_academic_years + 1, AcademicYear.find_all.size
  end

  def test_edit
    get :edit, 'id' => 2
    assert_rendered_file 'edit'
    assert_template_has 'academic_year'
    assert_valid_record 'academic_year'
  end

  def test_update
    post :update, 'id' => 2, 'academic_year'=>{"interim_report_text"=>"Do great", "name"=>"weego"}
    assert_redirected_to :action => 'edit', :id => 2
  end

  def test_destroy
    assert_not_nil AcademicYear.find(1)

    post :destroy, 'id' => 1
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      academic_year = AcademicYear.find(1)
    }
  end
end
