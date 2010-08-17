require 'helper'

class TestStation < Test::Unit::TestCase
  def test_get_on_line
    flexmock(WMATA::Station).should_receive(:get_all).with("LineCode" => "RD")
    WMATA::Station.get_on_line("RD")
  end
  
  def test_get_on_line_with_symbol
    flexmock(WMATA::Station).should_receive(:get_all).with("LineCode" => "RD")
    WMATA::Station.get_on_line(:red)    
  end
  
  def test_get
    flexmock(HTTParty).should_receive(:get).with("http://api.wmata.com/Rail.svc/json/JStationInfo?api_key=1234&StationCode=A4").and_return({"Things" => "1234"})
    station = WMATA::Station.get("A4")
    
    assert_equal "1234", station.things
  end
  
  def test_codes
    station = WMATA::Station.new("Code" => "A1", "StationTogether1" => "C2", "StationTogether2" => "D1")
    assert_equal ["A1", "C2", "D1"], station.codes.sort
  end
  
  def test_codes_with_partial_set
    station = WMATA::Station.new("Code" => "A1", "StationTogether2" => "D1")
    assert_equal ["A1", "D1"], station.codes.sort    
  end
  
  def test_line_codes
    station = WMATA::Station.new("LineCode1" => "RD", "LineCode2" => "BL", "LineCode3" => "GR", "LineCode4" => "OR")
    assert_equal ["BL", "GR", "OR", "RD"], station.line_codes.sort
  end
  
  def test_line_codes_with_partial_set
    station = WMATA::Station.new("LineCode1" => "RD", "LineCode3" => "GR", "LineCode4" => "OR")
    assert_equal ["GR", "OR", "RD"], station.line_codes.sort    
  end
  
  def test_lines
    flexmock(WMATA::Line).should_receive(:get).with("RD").and_return(OpenStruct.new("code" => "RD"))
    station = WMATA::Station.new("LineCode1" => "RD")
    
    assert_equal "RD", station.lines.first.code
  end
  
  def test_predictions
    flexmock(WMATA::Prediction).should_receive(:predict_for).and_return([])
    station = WMATA::Station.new("Code" => "A1")
    
    assert_equal [], station.predictions
  end
  
  def test_elevator_incidents
    flexmock(WMATA::ElevatorIncident).should_receive(:get_by_station).and_return([])
    station = WMATA::Station.new("Code" => "A1")
    
    assert_equal [], station.elevator_incidents  
  end
  
  def test_to_s
    station = WMATA::Station.new("Code" => "A1")
    assert_equal "A1", station.to_s
  end
end