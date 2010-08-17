module WMATA
  class Line < Resource
    service "Rail"
    endpoint "JLines"
    
    class <<self
      alias_method :get_all_without_memoize, :get_all
        
      # Memoize this since (a) there's no way to ask for just one line and
      # (b) they're unlikely to change while we're doing a request.
      def get_all(params)
        @lines ||= get_all_without_memoize(params)
      end
    end
    
    def start_station
      @start_station ||= Station.get(@attrs['StartStationCode'])
    end
    
    def end_station
      @end_station ||= Station.get(@attrs['EndStationCode'])
    end
    
    def internal_destinations
      [@attrs['InternalDestination1'], @attrs['InternalDestination2']].compact.map do |s| 
        Station.get(s)
      end
    end
    
    def rail_incidents
      @incidents ||= RailIncident.get_by_line(self)
    end
    
    alias_method :incidents, :rail_incidents
    
    def route
      Station.get_on_line(code)
    end
    
    alias_method :stations, :route
    
    def get(code)
      get_all.select {|l| l.code == code}.pop
    end
    
    def code
      @attrs['LineCode']
    end
    
    def to_s
      code
    end
  end
end