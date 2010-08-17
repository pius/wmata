require 'helper'

class TestStationEntrance < Test::Unit::TestCase
  def test_station_codes
    station = WMATA::StationEntrance.new("StationCode1" => "A1", "StationCode2" => "A2")
    assert_equal ["A1","A2"], station.station_codes.sort
  end
  
  def test_station_codes_with_partial_set
    station = WMATA::StationEntrance.new("StationCode2" => "A2")
    assert_equal ["A2"], station.station_codes.sort 
  end
end