module WMATA
  class StationEntrance < Resource
    service "Rail"
    endpoint "JStationEntrances"
    
    def station_codes
      [@attrs['StationCode1'], @attrs['StationCode2']].compact
    end
    
    def station
      @station ||= Station.get(station_codes.first)
    end
  end
end