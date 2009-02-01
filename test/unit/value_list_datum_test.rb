require File.dirname(__FILE__) + '/../test_helper'

class ValueListDatumTest < Test::Unit::TestCase
  fixtures :value_list_data

  def setup
    @value_list_datum = ValueListDatum.find(1)
  end

  # Replace this with your real tests.
  def test_truth
    assert_kind_of ValueListDatum,  @value_list_datum
  end
end
