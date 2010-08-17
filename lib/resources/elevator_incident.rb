module WMATA
  class ElevatorIncident < Resource
    service "Incidents"
    endpoint "ElevatorIncidents"
    
    def self.get_by_station(affected_station)
      @incidents ||= get_all
      @incidents.select {|i| i.station_code == affected_station.to_s }.pop
    end
    
    def affected_station
      Station.get(@attrs['StationCode'])
    end

    alias_method :station, :affected_station
    
    def date_out_of_service
      Time.parse(@attrs['DateOutOfServ'])
    end
    
    def date_updated
      Time.parse(@attrs['DateUpdated'])
    end
  end
end