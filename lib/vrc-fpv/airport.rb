require 'net/http'

class HeadingError < StandardError; end

class Airport
  # Airport's ICAO code.
  attr_accessor :code
  # Airport's full name.
  attr_accessor :name
  # Airport's magnetic variance from true north.
  attr_accessor :variance
  
  # Params:
  # :code, :name, :variance
  def initialize(**kvargs)
    @code     = kvargs.fetch :code, ''
    @name     = kvargs.fetch :name, ''
    @variance = kvargs.fetch :variance, 17.0 # TODO: Detect this intelligently.
  end
  
  # Discover the airport's full name based
  # on ICAO code.
  def discover_name
  end
  
  # Discover the airport's magnetic variance
  # based on ICAO code.
  def discover_variance
  end
  
  # Calculate the true heading to the specified airport.
  # Takes an ICAO code or Airport object.
  def true_heading_to(arrival)
    heading_uri = "http://www6.landings.com/cgi-bin/nph-dist_apt?airport1=#{@code.downcase}&airport2=#{arrival.to_s.strip.downcase}"
    response = Net::HTTP.get URI heading_uri
    r = response.scan /(?:heading:)\s*([\d\.]+)\s+/
    
    raise HeadingError, "Heading from #{@code.upcase} to @arrival.to_s.upcase not found." \
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
    @code
  end
  
end