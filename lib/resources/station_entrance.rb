module WMATA
  # A resource class representing a station entrance (even if it's just an elevator).
  #
  # Available attribute methods:
  #
  # * +id+ - ID of the entrance.
  # * +name+ - The name of the entrance.
  # * +description+ - A description of the entrance.
  # * +lat+ - The entrance's latitude.
  # * +lon+ - The entrance's longitude.
  #
  class StationEntrance < Resource
    service "Rail"
    endpoint "JStationEntrances"
    
    # Get station codes that this entrance serves.
    def station_codes
      [@attrs['StationCode1'], @attrs['StationCode2']].compact
    end
    
    # Get the +Station+ instance for this entrance.
    def station
      @station ||= Station.get(station_codes.first)
    end
    
    def latitude
      @attrs['Lat']
    end
    
    def longitude
      @attrs['Lon']
    end
    
    def coordinates
      [latitude, longitude]
    end
    
    alias_method :coords, :coordinates
  end
end