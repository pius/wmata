module WMATA
  class PathSegment < Resource
    service "Rail"
    endpoint "JPath"
    
    def station
      @station ||= Station.get(@attrs['StationCode'])
    end
    
    def line
      @line ||= Line.get(@attrs['LineCode'])
    end
    
    def index
      @attrs['SeqNum']
    end
  end
end