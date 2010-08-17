require 'helper'

class TestResource < Test::Unit::TestCase
  class Faker < WMATA::Resource
  end
  
  def setup
    @fake = Faker.new("method1" => "win", "MethodTwo" => "epic")
  end
  
  def test_method_mapping
    assert_nothing_raised do
      assert_equal "win", @fake.method1
    end
  end
  
  def test_method_mapping_with_camel_case
    assert_nothing_raised do
      assert_equal "epic", @fake.method_two
    end
  end
  
  def test_method_missing_fails_if_missing
    assert_raises(NoMethodError) do
      @fake.whateva
    end
  end
  
  def test_service_set
    Faker.service "Rail"
    assert_equal "Rail", Faker.service
  end
  
  def test_endpoint_set
    Faker.endpoint "Rail"
    assert_equal "Rail", Faker.endpoint
  end
  
  def test_to_query_string
    assert_equal "&things=yes&whatever=no", Faker.to_query_string(:things => "yes", :whatever => "no")
  end
end