module WMATA
  class Prediction < Resource
    service "StationPrediction"
    
    def self.predict_for(station_code)
      url = WMATA.base_url % [service, "GetPrediction/#{station_code}", ""]
      HTTParty.get(url).first.last.map {|values| new(values) }
    end
    
    def location
      @location ||= Station.get(@attrs['LocationCode'])
    end
    
    alias_method :station, :location
    
    def destination
      @destination ||= Station.get(@attrs['DestinationCode'])
    end
    
    def line_code
      @attrs['Line']
    end
    
    def line
      @line ||= Line.get(@attrs['Line'])
    end
  end
end