require File.dirname(__FILE__) + '/../test_helper'

class ReportCommentTest < Test::Unit::TestCase
  fixtures :report_comments

  def setup
    @report_comment = ReportComment.find(1)
  end

  # Replace this with your real tests.
  def test_truth
    assert_kind_of ReportComment,  @report_comment
  end
end
