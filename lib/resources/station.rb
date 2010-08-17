module WMATA
  class Station < Resource
    service "Rail"
    endpoint "JStations"
    
    SYMBOL_TO_LINES_MAP = {
      :red => "RD",
      :blue => "BL",
      :orange => "OR", 
      :green => "GR", 
      :yellow => "YE"
    }
    
    def self.get_on_line(line)
      line = SYMBOL_TO_LINES_MAP[line] if line.is_a?(Symbol)
      get_all("LineCode" => line.to_s)
    end
    
    def self.get(code)
      url = WMATA.base_url % [service, "JStationInfo", to_query_string("StationCode" => code)]
      new(HTTParty.get(url))
    end
    
    def codes
      [@attrs['Code'], @attrs['StationTogether1'], @attrs['StationTogether2']].compact
    end
    
    def line_codes
      [@attrs['LineCode1'], @attrs['LineCode2'], @attrs['LineCode3'], @attrs['LineCode4']].compact
    end
    
    def lines
      @lines ||= line_codes.map {|l| Line.get(l)}
    end
    
    def predictions
      @predictions ||= Prediction.predict_for(self)
    end
    
    def elevator_incidents
      @elevator_incidents ||= ElevatorIncident.get_by_station(self)
    end
    
    def to_s
      @attrs['Code']
    end
  end
end