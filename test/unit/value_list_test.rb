require File.dirname(__FILE__) + '/../test_helper'

class ValueListTest < Test::Unit::TestCase
  fixtures :value_lists

  def setup
    @value_list = ValueList.find(1)
  end

  # Replace this with your real tests.
  def test_truth
    assert_kind_of ValueList,  @value_list
  end
end
