require File.dirname(__FILE__) + '/../test_helper'

class PupilTest < Test::Unit::TestCase

  fixtures :pupils, :school_sessions, :pupil_sets, :reports, :setlinks, :generic_report_element_data
  
  def test_add_and_remove_from_pupil_set

    # create a pupil and a set
    jimmy = Pupil.create("known_as"=>"Jimmy", "surname"=>"Page", "academic_year_id"=>"1")
    jimmy.save
    jane= Pupil.create("known_as"=>"Jane", "surname"=>"Page", "academic_year_id"=>"1")
    jane.save
    assert_instance_of Pupil, jimmy
    assert_instance_of Pupil, jane
    #add jimmy to S1 pupil set
    first_pupil_set=PupilSet.find(4)
    assert_instance_of PupilSet, first_pupil_set
    jimmy.add_to_set(first_pupil_set)
    jane.add_to_set(first_pupil_set)
    # check that jimmy is now in the set
    assert_equal jimmy.id, first_pupil_set.pupils.find(jimmy.id).pupil_id.to_i
    assert_equal jane.id, first_pupil_set.pupils.find(jane.id).pupil_id.to_i
    assert_instance_of(PupilSet, jimmy.pupil_sets.find(first_pupil_set.id))

    #now remove jimmy from set_code
    jimmy.remove_from_set(first_pupil_set)
    #check that jane is still in set
    assert_equal jane.id, first_pupil_set.pupils.find(jane.id).pupil_id.to_i

    # now remove jane too
    jane.remove_from_set(first_pupil_set)

    # now check that no one is in the set
    assert_equal(first_pupil_set.pupils, [])
    #create another set that is not for Jimmy's yeargroup
    bad_set=PupilSet.create("id"=>"200","set_code"=>"1/MA/Y3", "academic_year_id"=>"3", "pupil_set_end_date"=>"NULL")
    assert_instance_of(PupilSet, bad_set)
    #try to add jimmy to set
    jimmy.add_to_set(bad_set)

    # check that this doesn't work
    assert_equal( bad_set.pupils, [])
    #jimmy.destroy
    #@first_pupil_set.destroy
  end
  
  def test_create_read_destroy
    jimmy = Pupil.create("known_as"=>"Jimmy", "surname"=>"Page")
    assert_instance_of Pupil,  jimmy
    # read him back
    agent = Pupil.find(jimmy.id)

    # compare the usernames
    assert_equal jimmy.known_as, agent.known_as

    jimmy.update_attributes({"surname"=>"Carter"})
    agent = Pupil.find(jimmy.id)
    assert_equal agent.surname, "Carter"
    assert jimmy.destroy
  end

  def test_count_generic_element_values
    test_pupil=Pupil.find(1)
    assert_equal test_pupil.count_generic_element_values(1,"A"), 3
  end

end
