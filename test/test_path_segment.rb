require 'helper'

class TestPathSegment < Test::Unit::TestCase
  def test_station
    flexmock(WMATA::Station).should_receive(:get).and_return(OpenStruct.new(:name => "Winner"))
    segment = WMATA::PathSegment.new("StationCode" => "A4")
    
    assert_equal "Winner", segment.station.name
  end
  
  def test_line
    flexmock(WMATA::Line).should_receive(:get).and_return(OpenStruct.new(:name => "Winner"))
    segment = WMATA::PathSegment.new("LineCode" => "A4")
    
    assert_equal "Winner", segment.line.name
  end
  
  def test_index
    segment = WMATA::PathSegment.new("SeqNum" => "1")
    assert_equal "1", segment.index
  end
end