require 'net/http'

module ATCTools
  class NameDiscoveryError < StandardError; end
  class HeadingDiscoveryError < StandardError; end

  class Airport
    # Airport's ICAO code.
    attr_accessor :code
    # Airport's full name.
    attr_writer   :name
    # Airport's magnetic variance from true north.
    attr_accessor :variance
    
    # URI of the web page used for the last airport name lookup.
    attr_reader   :name_uri
    # URI of the web page used for the last heading lookup.
    attr_reader   :heading_uri
    
    # Params:
    # :code, :name, :variance
    def initialize(code = nil, **kvargs)
      @code     = code || (kvargs.fetch :code, '')
      @name     = kvargs.fetch :name, ''
      @variance = kvargs.fetch :variance, 20.0 # ZSE Standard Variance
    end
    
    # Airport's full name.
    def name
      discover_name if @name.empty?
      @name
    end
    
    # Discover the airport's full name based
    # on ICAO code.
    def discover_name
      @name_uri = "http://www.airnav.com/airport/#{@code.to_s.downcase}"
      response = Net::HTTP.get URI name_uri
      
      l = response.scan %r{(?i:<title>)(?:AirNav:\s*\w*\s*-\s*)(.*)(?i:</title>)}
      
      unless l.flatten.count > 0
        @name = ' '
        raise ATCTools::NameDiscoveryError, "Could not discover name for #{@code.to_s.upcase}"
      end
        
        
      @name = l.flatten.first
    end
    
    # Discover the airport's magnetic variance
    # based on ICAO code.
    def discover_variance
    end
    
    # Calculate the true heading to the specified airport.
    # Takes an ICAO code or Airport object.
    def true_heading_to(arrival)
      @heading_uri = "http://www6.landings.com/cgi-bin/nph-dist_apt?airport1=#{@code.downcase}&airport2=#{arrival.to_s.strip.downcase}"
      response = Net::HTTP.get URI heading_uri
      r = response.scan /(?:heading:)\s*([\d\.]+)\s+/
      
      raise ATCTools::HeadingDiscoveryError, "Heading from #{@code.upcase} to #{arrival.to_s.upcase} not found." \
        unless r.count > 0
      
      true_hdg = r.flatten.first.to_f
    end
    
    # Calculate the true heading from the specified airport.
    # Takes an ICAO code or Airport object.
    def true_heading_from(departure)
      360.0 - true_heading_to(departure)
    end
    
    # Calculate the magnetic heading to the specified airport.
    # Takes an ICAO code or Airport object.
    def magnetic_heading_to(arrival)
      true_to_magnetic true_heading_to(arrival)
    end
    
    # Calculate the magnetic heading from the specified airport.
    # Takes an ICAO code or Airport object.
    def magnetic_heading_from(departure)
      true_to_magnetic true_heading_from(departure)
    end
    
    # Convert a true heading to magnetic based on the airport's
    # magnetic variance.
    def true_to_magnetic(heading)
      heading - @variance
    end
    
    # Convert a magnetic heading to true based on the airport's
    # magnetic variance.
    def magnetic_to_true(heading)
      heading + @variance
    end
    
    # Print the Airport ICAO code.
    # Allows the object to act as a direct replacement for string input.
    def to_s
      @code.to_s.upcase
    end
    
  end
end