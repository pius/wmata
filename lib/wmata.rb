$:.unshift(File.dirname(__FILE__))

require 'rubygems'
require 'httparty'
require 'forwardable'

require 'resource'
require 'resources/line'
require 'resources/station'
require 'resources/rail_incident'
require 'resources/elevator_incident'
require 'resources/prediction'
require 'resources/path_segment'
require 'resources/station_entrance'

module WMATA
  BASE_URL = "http://api.wmata.com/%s.svc/json/%s?api_key=%s%s"
  
  class <<self
    attr_accessor :api_key
        
    def base_url
      BASE_URL.dup % ["%s", "%s", @api_key, "%s"]    
    end
    
    def lines
      Line.get_all
    end
    
    def stations
      Station.get_all
    end
    
    def station(code)
      Station.get(code)
    end
    
    def stations_on_line(code)
      Station.get_on_line(code)
    end
    
    def predict_for(station="All")
      Prediction.predict_for(station)
    end
    
    def rail_incidents
      RailIncident.get_all
    end
    
    alias_method :incidents, :rail_incidents
    
    def elevator_incidents
      ElevatorIncident.get_all
    end
    
    def build_path(from, to)
      PathSegment.get_all("FromStationCode" => from, "ToStationCode" => to)
    end
    
    def entrances(from={})
      params = {:lat => 0, :lon => 0, :radius => 500}.merge(from)
      StationEntrance.get_all(params)
    end
    
    alias_method :station_entrances, :entrances
    alias_method :entrances_near, :entrances
  end
end