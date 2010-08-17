module WMATA
  # A resource class representing a rail incident (e.g., garbage on the rails delaying a train).
  #
  # Available attribute methods:
  #
  # * +incident_id+ - ID of the nicident
  # * +incident_type+ - Type of the nicident
  # * +date_updated+ - Date and time where information was updated.
  # * +delay_severity+ - Severity of delay (if any). Can be +:minor+, +:major+, or +:medium+.
  # * +description+ - Description what happened.
  # * +emergency_text+ - Some text for emergency (if any).
  # * +start_location_full_name+ - Station where delay starts.
  # * +end_location_full_name+ - Station where delay ends.
  # * +passenger_delay+ - Delay in minutes.
  #
  class RailIncident < Resource
    service "Incidents"
    endpoint "Incidents"

    # Get all rail incidents by the line; can be a line code string or
    # a +Line+ instance.
    def self.get_by_line(line)
      @incidents ||= get_all
      @incidents.select {|i| i.line_codes_affected.include?(line.to_s)}
    end
    
    # Get a +Time+ object representing the last time this API data entry
    # was updated.
    def date_updated
      Time.parse(@attrs['DateUpdated'])
    end
    
    # Get an array of the line codes affected by this incident.
    def line_codes_affected
      @attrs['LinesAffected'].split(";").reject {|s| s.empty? || s.nil?}
    end
    
    # Get +Line+ instances for the lines affected by this incident.
    def lines_affected
      @lines_affected = line_codes_affected.map {|l| Line.get(l.strip)}
    end
    
    # ID of the incident.
    def incident_id
      @attrs['IncidentID']
    end
    
    def delay_severity
      @attrs['DelaySeverity'].to_s.downcase.to_sym
    end
  end
end