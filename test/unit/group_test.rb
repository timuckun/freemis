require File.dirname(__FILE__) + '/../test_helper'

class GroupTest < Test::Unit::TestCase

  fixtures :groups
  fixtures :groups_users
  fixtures :users
  
  def setup
  end

  # Replace this with your real tests.
  def test_truth
    assert groups(:teacher_group).has_user(users(:teacheruser))
    assert ! groups(:admin_group).has_user(users(:teacheruser))
    assert groups(:admin_group).has_user(users(:adminuser))
  end
end
