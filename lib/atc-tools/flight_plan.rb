module ATCTools
  class FlightPlan
    # Aircraft callsign.
    attr_accessor :callsign
    # Aircraft type/info.
    attr_accessor :aircraft
    # Flight rules.
    attr_accessor :rules
    # Departure airport.
    attr_accessor :depart
    # Arrival airport.
    attr_accessor :arrive
    # Alternate airport.
    attr_accessor :alternate
    # Cruising altitude.
    attr_accessor :cruise
    # Squawk code.
    attr_accessor :squawk
    # Flight route.
    attr_accessor :route
    # Additional remarks/notes.
    attr_accessor :remarks
    
    def initialize(**kvargs)
      @callsign  = kvargs.fetch :callsign,  ''
      @aircraft  = kvargs.fetch :aircraft,  Aircraft.new
      @rules     = kvargs.fetch :rules,     ''
      @depart    = kvargs.fetch :depart,    Airport.new
      @arrive    = kvargs.fetch :arrive,    Airport.new
      @alternate = kvargs.fetch :alternate, Airport.new
      @cruise    = kvargs.fetch :cruise,    0
      @squawk    = kvargs.fetch :squawk,    '0000'
      @route     = kvargs.fetch :route,     ''
      @remarks   = kvargs.fetch :remarks,   ''
    end
    
    # Validate the flight level given the arrival airport
    # and flight rules.
    def flight_level_valid?
    end
    
  end
end