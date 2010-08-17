module WMATA
  # A resource class representing a rail line.
  #
  # Available attribute methods:
  #
  # * +display_name+ - The public name (color) of the line.
  # * +start_station_code+ - The code associated with the first station on the line.
  # * +end_station_code+ - The code associated with the last station on the line.
  # * +internal_destination1+ - Some trains can start/finish their trips not only at the first/last station, but at intermediate stations along the line.
  # * +internal_destination2+ - See +internal_destination+.
  #
  class Line < Resource
    service "Rail"
    endpoint "JLines"
    
    SYMBOL_TO_LINES_MAP = {
      :red => "RD",
      :blue => "BL",
      :orange => "OR", 
      :green => "GR", 
      :yellow => "YE"
    }
    
    class <<self
      alias_method :get_all_without_memoize, :get_all
        
      # NOTE: We memoize this since (a) there's no way to ask for just one line and
      # (b) they're unlikely to change while we're doing a request.
      def get_all(params = {})
        @lines ||= get_all_without_memoize(params)
      end
      
      def symbol_to_line_code(symbol)
        SYMBOL_TO_LINES_MAP[symbol]
      end
      
      # Get a specific line, identified by line code (e.g., "RD") or a +Symbol+
      # string name (e.g., +:red+).
      def get(code)
        code = Line.symbol_to_line_code(code) if code.is_a?(Symbol)
        get_all.select {|l| l.code == code}.pop
      end
    end
    
    # Get the first station on this line.
    def start_station
      @start_station ||= Station.get(@attrs['StartStationCode'])
    end
    
    # Get the last station on this line.
    def end_station
      @end_station ||= Station.get(@attrs['EndStationCode'])
    end
    
    # Get all internal destinations (some lines "end" or "begin" at more than
    # one station).
    def internal_destinations
      [@attrs['InternalDestination1'], @attrs['InternalDestination2']].compact.map do |s| 
        Station.get(s)
      end
    end
    
    # Get all rail incidents on this line.
    def rail_incidents
      @incidents ||= RailIncident.get_by_line(self)
    end
    
    alias_method :incidents, :rail_incidents
    
    # Get all the stations on this line ordered by the route.
    def route
      Station.get_on_line(code)
    end
    
    alias_method :stations, :route
    
    # Returns the line's code (also available as +line_code+).
    def code
      @attrs['LineCode']
    end
    
    def to_s
      code
    end
  end
end