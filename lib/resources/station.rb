module WMATA
  # Resource class representing a station in the metro system.
  #
  # Available attribute methods:
  #
  # * +code - The code associated with a specific station.
  # * +name - The name of the station.
  # * +lat+ - The latitude of the station.
  # * +lon+ - The longitude of the station.
  #
  # StationTogether2 - Unused.
  class Station < Resource
    service "Rail"
    endpoint "JStations"
    
    # Get all stations on a given line; argument can be a +Line+ instance, a string
    # line code, or a symbol name (e.g., +:red+).
    def self.get_on_line(line)
      line = Line.symbol_to_line_code(line) if line.is_a?(Symbol)
      get_all("LineCode" => line.to_s)
    end
    
    # Get a specific station by its code.
    def self.get(code)
      url = WMATA.base_url % [service, "JStationInfo", to_query_string("StationCode" => code)]
      new(HTTParty.get(url))
    end
    
    # Get all possible codes for this station (some stations are in together with another so
    # they are technically identified by two station codes).
    def codes
      [@attrs['Code'], @attrs['StationTogether1'], @attrs['StationTogether2']].compact
    end
    
    # Get the line codes for this station (some stations serve more than one line).
    def line_codes
      [@attrs['LineCode1'], @attrs['LineCode2'], @attrs['LineCode3'], @attrs['LineCode4']].compact
    end
    
    # Get +Line+ instances for the lines serviced by this station.
    def lines
      @lines ||= line_codes.map {|l| Line.get(l)}
    end
    
    # Get train arrival predictions for this station.
    def predictions
      @predictions ||= Prediction.predict_for(self)
    end
    
    # Get all elevator incidents affecting this station.
    def elevator_incidents
      @elevator_incidents ||= ElevatorIncident.get_by_station(self)
    end
    
    # Build a path from this station to another identified by its code or as a 
    # +Station+ instance.
    def path_to(to)
      WMATA.build_path(self, to)
    end
    
    # Build a path from this station to another station identified by its code
    # or as a +Station+ instance.
    def path_from(from)
      WMATA.build_path(from, self)
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
    
    def to_s
      @attrs['Code']
    end
  end
end