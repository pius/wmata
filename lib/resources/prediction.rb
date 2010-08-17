module WMATA
  # A resource class representing train arrival prediction information.
  #
  # Available attribute methods:
  #
  # * +car+ - Number of cars in a particular train (usually 6 or 8).
  # * +destination_code+ - The ID of destination station.
  # * +destination_name+ - The name of destination station.
  # * +group+ - Track number (1 or 2).
  # * +line+ - ID of the metro line.
  # * +location_code+ - ID of the station where the train is arriving.
  # * +location_name+ - The name of the station where the train is arriving.
  # * +arrival_status+ - The minutes to train arrival. Can be +:boarding+, +:arrived+, or positive number.
  #
  class Prediction < Resource
    service "StationPrediction"
    
    # Get train arrival prediction information for a given station; can
    # be a station code as a string or a +Station+ instance.
    def self.predict_for(station_code)
      url = WMATA.base_url % [service, "GetPrediction/#{station_code.to_s}", ""]
      HTTParty.get(url).first.last.map {|values| new(values) }
    end
    
    # Get the arriving station this prediction applies to.
    def location
      @location ||= Station.get(@attrs['LocationCode'])
    end
    
    alias_method :station, :location
    
    # Get the destination of the train for this prediction.
    def destination
      @destination ||= Station.get(@attrs['DestinationCode'])
    end
    
    # Get the line code the line this prediction's station is on.
    def line_code
      @attrs['Line']
    end
    
    # Get the +Line+ instance for this prediction's station's line.
    def line
      @line ||= Line.get(@attrs['Line'])
    end
    
    # Get the arrival status of the train.  Can be +:boarding+, +:arrived+, or 
    # the number of minutes until the train will arrive.
    def arrival_status
      if @attrs['Min'] == "BRD"
        :boarding
      elsif @attrs['Min'] == "ARR"
        :arrived
      else
        @attrs['Min'].to_i
      end
    end
  end
end