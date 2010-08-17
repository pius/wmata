require 'helper'

class TestWmata < Test::Unit::TestCase
  def setup
    flexmock(WMATA).should_receive(:api_key).and_return("1234")
  end
  
  def test_lines
    mock_resource(WMATA::Line)
    WMATA.lines
  end
  
  def test_stations
    mock_resource(WMATA::Station)
    WMATA.stations
  end
  
  def test_station
    flexmock(WMATA::Station).should_receive(:get).with("A2")
    WMATA.station("A2")
  end
  
  def test_stations_on_line
    flexmock(WMATA::Station).should_receive(:get_on_line).with(:red)
    WMATA.stations_on_line(:red)
  end
  
  def test_predict_for
    flexmock(WMATA::Prediction).should_receive(:predict_for).with("A7")
    WMATA.predict_for("A7")
  end
  
  def test_predict_for_with_default
    flexmock(WMATA::Prediction).should_receive(:predict_for).with("All")
    WMATA.predict_for
  end
  
  def test_rail_incidents
    mock_resource(WMATA::RailIncident)
    WMATA.rail_incidents
  end
  
  def test_elevator_incidents
    mock_resource(WMATA::ElevatorIncident)
    WMATA.elevator_incidents    
  end
  
  def test_build_path
    flexmock(WMATA::PathSegment).should_receive(:get_all).with("FromStationCode" => "37.80", "ToStationCode" => "88.7")
    WMATA.build_path("37.80", "88.7")
  end
  
  def test_entrances
    flexmock(WMATA::StationEntrance).should_receive(:get_all).with(:lat => 0, :lon => 0, :radius => 500)
    WMATA.entrances
  end
  
  def test_entrances_with_specifics
    flexmock(WMATA::StationEntrance).should_receive(:get_all).with(:lat => 39.0, :lon => 0, :radius => 2000)
    WMATA.entrances(:lat => 39.0, :radius => 2000)
  end
  
  def mock_resource(resource_class)
    flexmock(resource_class).should_receive(:get_all)
  end
end
