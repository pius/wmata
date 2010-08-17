module WMATA
  class Resource
    class <<self
      def get_all(params={})
        url = WMATA.base_url % [service, endpoint, to_query_string(params)]
        HTTParty.get(url).first.last.map {|values| new(values) }
      end
      
      alias_method :find_all, :get_all
    
      def service(value=nil)
        @service = value if value
        @service || "#{self.name.capitalize}s"
      end
      
      def endpoint(value=nil)
        @endpoint = value if value
        @endpoint || "#{self.name.capitalize}s"
      end
      
      def to_query_string(params)
        "&" + params.map {|k, v| "#{k.to_s}=#{v}"}.join("&")
      end
    end

    attr_reader :attrs

    def initialize(attrs={})
      @attrs = attrs
    end

    def method_missing(m, *args)
      camel_cased = m.to_s.gsub(/\/(.?)/) { "::#{$1.upcase}" }.gsub(/(?:^|_)(.)/) { $1.upcase }
      @attrs[m.to_s] or @attrs[camel_cased] or super
    end
  end
end