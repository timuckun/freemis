require File.dirname(__FILE__) + '/../test_helper'

class ActionTest < Test::Unit::TestCase
  fixtures :users, :groups, :actions, :accesses, :groups_users

  def test_accesses
    assert_instance_of User, users(:adminuser)
    assert actions(:admin_action).accessible(users(:adminuser))
    assert !actions(:admin_action).accessible(users(:teacheruser))
    assert  actions(:teacher_action).accessible(users(:teacheruser))
    assert !actions(:teacher_action).accessible(users(:adminuser))
  end
end
