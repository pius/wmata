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
    
    # Get the base URL based on the API key given.  Used in 
    # nearly every method that contacts the remote API.
    def base_url
      BASE_URL.dup % ["%s", "%s", @api_key, "%s"]    
    end
    
    # Get all rail lines.
    #
    #    WMATA.lines.map {|l| l.code}
    #    # => ["RD", "BL", "GR", "OR", "YE"]
    #
    def lines
      Line.get_all
    end
    
    # Get all stations.
    #
    #     WMATA.stations.map {|s| s.name }
    #     # => ["McPherson Square", "Metro Center", ...]
    #
    def stations
      Station.get_all
    end
    
    # Get a specific station by code.
    #
    #     WMATA.station("C02")
    #     # => #<Station:0x1205aee8 "McPherson Square">
    #
    def station(code)
      Station.get(code)
    end
    
    # Get an array of stations on a particular line.  Can be called
    # with a line code (e.g., RD) or a symbol for the line name
    # (e.g., +:red+).
    #
    #     WMATA.stations_on_line(:red)
    #     # => [#<Station:0x0702aca8>, ...]
    #
    def stations_on_line(code)
      Station.get_on_line(code)
    end
    
    # Get station predictions (i.e., train arrival information seen on
    # station terminals) for a specific station; if no station
    # code is provided, it will get predictions for all stations.
    #
    #     predictions = WMATA.predict_for("C02")
    #     # => [#<Prediction:0x1205aee8 ...>, ...]
    #     puts "#{predictions.first.location_name} => #{predictions.first.destination_name}"
    #     # McPherson Square => Metro Center
    #
    def predict_for(station="All")
      Prediction.predict_for(station)
    end
    
    alias_method :get_predictions, :predict_for
    
    # Get an array of rail incidents for all lines; use the +incidents+ method
    # on +Line+ to get them for a specific line or the same method.
    #
    #     WMATA.rail_incidents.map {|i| i.description}
    #     # => ["Friendship Heights is closed...", ...]
    #
    def rail_incidents
      RailIncident.get_all
    end
    
    alias_method :incidents, :rail_incidents
    
    # Get an array of elevator incidents for all lines; use the +elevator_incidents+ 
    # method on +Station+ to get them for a specific station.
    #
    #     WMATA.elevator_incidents.map {|i| i.symptom_code}
    #     # => ["1419", ...]
    #
    def elevator_incidents
      ElevatorIncident.get_all
    end
    
    # Map a path between two stations, identified by their station codes; returns an 
    # array of stations ordered by the path.  You can also provide +Station+ instances
    # and get a path between them.
    #
    #     WMATA.build_path("C02", "A01")
    #     # => [#<Station:0x0702aca8>, ...]
    #
    def build_path(from, to)
      PathSegment.get_all("FromStationCode" => from, "ToStationCode" => to)
    end
    
    # Find entrances near a given latitude and longitude within a given radius (in meters).  
    # If no geolocation information is given, all entrances are returned.
    #
    #     WMATA.entrances(:lat => 28.82083, :lon => 88.9239423, :radius => 2000)
    #     # => [#<StationEntrance:0x0702aca8>, ...]
    #
    def entrances(from={})
      params = {:lat => 0, :lon => 0, :radius => 500}.merge(from)
      StationEntrance.get_all(params)
    end
    
    alias_method :station_entrances, :entrances
    alias_method :entrances_near, :entrances
  end
end