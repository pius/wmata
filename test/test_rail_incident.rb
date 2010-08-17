require 'helper'

class TestRailIncident < Test::Unit::TestCase
  def test_get_by_station
    fake_incidents = []
    5.times {|i| fake_incidents << OpenStruct.new(:line_codes_affected => ["RD", "BL#{i}"])}
    flexmock(WMATA::RailIncident).should_receive(:get_all).and_return(fake_incidents)
    
    assert_equal ["BL2", "RD"], WMATA::RailIncident.get_by_line("RD")[2].line_codes_affected.sort
  end
  
  def test_line_codes_affected
    incident = WMATA::RailIncident.new("LinesAffected" => "RD;BL;OR")
    assert_equal ["BL", "OR", "RD"], incident.line_codes_affected.sort
  end
  
  def test_lines_affected
    flexmock(WMATA::Line).should_receive(:get).and_return(WMATA::Line.new("Code" => "RD"))
    incident = WMATA::RailIncident.new("LinesAffected" => "RD;BL;OR")
    
    assert_equal 3, incident.lines_affected.length
  end
  
  def test_date_updated
    incident = WMATA::RailIncident.new("DateUpdated" => "2010-07-27T00:00:00")
    assert_equal Time.parse("07/27/2010"), incident.date_updated    
  end
end