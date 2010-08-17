require 'helper'

class TestPrediction< Test::Unit::TestCase
  def setup
    WMATA.api_key = "1234"
    @fake = OpenStruct.new(:name => "Winner")
    @prediction = WMATA::Prediction.new("LocationCode" => "A4", "DestinationCode" => "A3", "Line" => "RD")
  end
  
  def test_predict_for
    flexmock(HTTParty).should_receive(:get).with("http://api.wmata.com/StationPrediction.svc/json/GetPrediction/A4?api_key=1234").and_return([[{"Things" => 1234}]])
    prediction = WMATA::Prediction.predict_for("A4")
  end
  
  def test_location
    flexmock(WMATA::Station).should_receive(:get).and_return(@fake)
    
    assert_equal @fake, @prediction.location
  end
  
  def test_destination
    flexmock(WMATA::Station).should_receive(:get).and_return(@fake)
    
    assert_equal @fake, @prediction.destination 
  end
  
  def test_line_code
    assert_equal "RD", @prediction.line_code 
  end
  
  def test_line
    flexmock(WMATA::Line).should_receive(:get).and_return(@fake)
    
    assert_equal @fake, @prediction.line
  end
end