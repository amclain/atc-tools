require 'atc-tools/aircraft'
require 'atc-tools/airport'

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
    # Scratch pad.
    attr_accessor :scratchpad
    
    
    def initialize(**kvargs)
      @callsign   = kvargs.fetch :callsign,  ''
      @aircraft   = kvargs.fetch :aircraft,  ATCTools::Aircraft.new
      @rules      = kvargs.fetch :rules,     ''
      @depart     = kvargs.fetch :depart,    ATCTools::Airport.new
      @arrive     = kvargs.fetch :arrive,    ATCTools::Airport.new
      @alternate  = kvargs.fetch :alternate, ATCTools::Airport.new
      @cruise     = kvargs.fetch :cruise,    0
      @squawk     = kvargs.fetch :squawk,    '0000'
      @route      = kvargs.fetch :route,     ''
      @remarks    = kvargs.fetch :remarks,   ''
      @scratchpad = kvargs.fetch :scratchpad, ''
      
      @heading    = nil
    end
    
    # Magnetic heading from the departure to arrival airport.
    def heading
      altitude_valid? unless @heading # Run the validator to populate @heading.
      @heading
    end
    
    # Validate the cruising altitude given the arrival airport
    # and flight rules.
    def altitude_valid?
      @heading = @depart.magnetic_heading_to @arrive unless @heading
      
      # Strip the zeros off of the altitude for even/odd comparison.
      cruise_stripped = @cruise.to_s.gsub(/0/, '').to_i
      
      rules = @rules.upcase.to_sym
      case rules
      when :IFR
        return true if
          ((@heading < 180 || @heading >= 360) && cruise_stripped.odd?) ||
          ((@heading >= 180 && @heading < 360) && cruise_stripped.even?)
          
      when :VFR
      end
      
      return false
    end
    
    # Validate the flight plan.
    def validate
    end
    
    # Returns a human-readable version of the flight plan.
    def to_s
      data = <<EOS
Callsign:   #{@callsign}
A/C Type:   #{@aircraft}
Rules:      #{@rules}

Depart:     #{@depart}
Arrive:     #{@arrive} :: #{@arrive.name}
Alternate:  #{@alternate}

Cruise:     #{@cruise}
Scratchpad: #{@scratchpad}
Squawk:     #{@squawk}

Route:      #{@route}

Remarks:    #{@remarks}
EOS
    end
    
  end
end