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
    @variance = kvargs.fetch :variance, 0.0
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
  end
  
  # Calculate the true heading from the specified airport.
  # Takes an ICAO code or Airport object.
  def true_heading_from(departure)
  end
  
  # Calculate the magnetic heading to the specified airport.
  # Takes an ICAO code or Airport object.
  def magnetic_heading_to(arrival)
  end
  
  # Calculate the magnetic heading from the specified airport.
  # Takes an ICAO code or Airport object.
  def magnetic_heading_from(departure)
  end
  
  # Print the Airport ICAO code.
  # Allows the object to act as a direct replacement for string input.
  def to_s
    @code
  end
  
end