module WMATA
  # A class representing service incidents in elevators (e.g., an elevator is busted
  # going between the two floors of the station).
  #
  # Available attribute methods:
  #
  # * +display_order+ - Display priority
  # * +date_out_of_service+ - Date when elevator/escalator was switched off.
  # * +date_updated+ - Time when the information was last received.
  # * +location_description+ - Location of elevator/escalator.
  # * +station_code+ - Code of the station affected by the escalator/elevator incident.
  # * +station_name+ - Name of the station affected by the escalator/elevator incident.
  # * +symptom_code+ - ID of the reason why elevator/escalator was switched off.
  # * +symptom_description+ - Information why elevator/escalator was switched off.
  # * +time_out_of_service+ - Number of minutes the elevator has been out of service until last update of data.
  # * +unit_name+ - ID of the affected elevator/escalator.
  # * +unit_status+ - Can be "C" or "O": O means Out of service (has open issues) and C  means Operational (open issues were closed).
  # * +unit_type+ - "ESCALATOR" or "ELEVATOR"
  #
  class ElevatorIncident < Resource
    service "Incidents"
    endpoint "ElevatorIncidents"
    
    # Get the incidents by station; provide either a +Station+ instance
    # or a station code as the argument.
    def self.get_by_station(affected_station)
      @incidents ||= get_all
      @incidents.select {|i| i.station_code == affected_station.to_s }.pop
    end
    
    # Get the station affected by the problem.
    def affected_station
      Station.get(@attrs['StationCode'])
    end

    alias_method :station, :affected_station
    
    # Get a +Time+ object representing the time the elevator went out of 
    # service.
    def date_out_of_service
      Time.parse(@attrs['DateOutOfServ'])
    end
    
    # Get a +Time+ object representing the last time this API data entry
    # was updated.
    def date_updated
      Time.parse(@attrs['DateUpdated'])
    end
  end
end