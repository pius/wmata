module WMATA
  class RailIncident < Resource
    service "Incidents"
    endpoint "Incidents"

    def self.get_by_line(line)
      @incidents ||= get_all
      @incidents.select {|i| i.line_codes_affected.include?(line.to_s)}
    end
    
    def date_updated
      Time.parse(@attrs['DateUpdated'])
    end
    
    def line_codes_affected
      @attrs['LinesAffected'].split(";").reject {|s| s.empty? || s.nil?}
    end
    
    def lines_affected
      @lines_affected = line_codes_affected.map {|l| Line.get(l)}
    end
  end
end