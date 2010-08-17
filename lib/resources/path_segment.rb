module WMATA
  # A resource class representing a segment in a path between two stations.
  #
  # Available attribute methods:
  #
  # * +station_code+ - The ID code for an individual station.
  # * +station_name+ - The name of the Station.
  # * +line_code+ - The ID (color) of the Line associated with the path.
  # * +seq_num+ - The sequence of the station in the path.
  # * +distance_to_previous+ - Distance in feet from the previous station in the path.
  #
  class PathSegment < Resource
    service "Rail"
    endpoint "JPath"
    
    # Return the +Station+ instance representing the station on
    # this segment of the path.
    def station
      @station ||= Station.get(@attrs['StationCode'])
    end
    
    # Returns the +Line+ instance for the line this segment falls on.
    def line
      @line ||= Line.get(@attrs['LineCode'])
    end
    
    # The position this +PathSegment+ is in the overall path.
    def index
      @attrs['SeqNum']
    end
    
    # The distance to the previous station in the path.
    def distance_to_previous
      @attrs['DistanceToPrev']
    end
  end
end