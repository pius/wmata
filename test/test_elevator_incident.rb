require 'helper'

class TestElevatorIncident < Test::Unit::TestCase
  def test_get_by_station
    fake_incidents = []
    5.times {|i| fake_incidents << OpenStruct.new(:station_code => "A#{i}")}
    flexmock(WMATA::ElevatorIncident).should_receive(:get_all).and_return(fake_incidents)
    
    assert_equal "A2", WMATA::ElevatorIncident.get_by_station("A2").station_code
  end
  
  def test_affected_station
    flexmock(WMATA::Station).should_receive(:get).and_return(OpenStruct.new(:name => "Winner"))
    incident = WMATA::ElevatorIncident.new("StationCode" => "A4")
    
    assert_equal "Winner", incident.affected_station.name
  end
  
  def test_date_out_of_service
    incident = WMATA::ElevatorIncident.new("DateOutOfServ" => "2010-07-27T00:00:00")
    assert_equal Time.parse("07/27/2010"), incident.date_out_of_service
  end
  
  def test_date_updated
    incident = WMATA::ElevatorIncident.new("DateUpdated" => "2010-07-27T00:00:00")
    assert_equal Time.parse("07/27/2010"), incident.date_updated    
  end
end