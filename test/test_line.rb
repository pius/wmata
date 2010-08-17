class TestLine < Test::Unit::TestCase
  def test_start_station
    flexmock(WMATA::Station).should_receive(:get).and_return(OpenStruct.new(:name => "Winner"))
    line = WMATA::Line.new("StartStationCode" => "A4")
    
    assert_equal "Winner", line.start_station.name
  end
  
  def test_end_station
    flexmock(WMATA::Station).should_receive(:get).and_return(OpenStruct.new(:name => "Winner"))
    line = WMATA::Line.new("EndStationCode" => "A4")
    
    assert_equal "Winner", line.end_station.name    
  end
  
  def test_internal_destinations
    flexmock(WMATA::Station).should_receive(:get).with("A1").and_return(OpenStruct.new(:name => "Winner"))
    flexmock(WMATA::Station).should_receive(:get).with("A2").and_return(OpenStruct.new(:name => "Failure"))
    line = WMATA::Line.new("InternalDestination1" => "A1", "InternalDestination2" => "A2")
    
    assert_equal ["Failure", "Winner"], line.internal_destinations.map {|d| d.name}.sort
  end
  
  def test_internal_destinations_with_partial_set
    flexmock(WMATA::Station).should_receive(:get).with("A1").and_return(OpenStruct.new(:name => "Winner"))
    line = WMATA::Line.new("InternalDestination1" => "A1")
    
    assert_equal ["Winner"], line.internal_destinations.map {|d| d.name}.sort    
  end
  
  def test_rail_incidents
    flexmock(WMATA::RailIncident).should_receive(:get_by_line).and_return([OpenStruct.new(:name => "Winner")])
    line = WMATA::Line.new("LineCode" => "RD")
    
    assert_equal ["Winner"], line.rail_incidents.map(&:name)
  end
  
  def test_route
    flexmock(WMATA::Station).should_receive(:get_on_line).and_return([OpenStruct.new(:name => "Winner")])
    line = WMATA::Line.new("LineCode" => "RD")
    
    assert_equal ["Winner"], line.route.map(&:name)
  end
  
  def test_get
    flexmock(WMATA::Station).should_receive(:get_on_line).and_return([OpenStruct.new(:name => "Winner")])
    line = WMATA::Line.new("LineCode" => "RD")
    
    assert_equal ["Winner"], line.route.map(&:name)    
  end
  
  def test_code
    line = WMATA::Line.new("LineCode" => "RD")
    assert_equal "RD", line.code
  end
  
  def test_to_s
    line = WMATA::Line.new("LineCode" => "RD")
    assert_equal "RD", line.to_s    
  end
end