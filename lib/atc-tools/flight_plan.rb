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
    attr_reader :cruise
    # Squawk code.
    attr_accessor :squawk
    # Flight route.
    attr_accessor :route
    # Additional remarks/notes.
    attr_accessor :remarks
    # Scratch pad.
    attr_accessor :scratchpad
    
    # Params:
    #   :callsign, :aircraft, :rules, :depart, :arrive, :alternate, :cruse,
    #   :squawk, :route, :remarks, :scratchpad
    #   -- See instance variables for descriptions.
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
      # TODO: This can cause a bug if the destination airport is changed
      #       after the heading is calculated. Although a new FlightPlan
      #       object should be created in this case, the problem should
      #       still be fixed.
      @heading = @depart.magnetic_heading_to @arrive unless @heading
      
      # Strip the zeros off of the altitude for even/odd comparison.
      cruise_stripped = @cruise.to_s.gsub(/0/, '').to_i
      is_north_east = (@heading < 180 || @heading >= 360)
      
      rules = @rules.upcase.to_sym
      case rules
      when :IFR
        above_fl410 = @cruise.to_i / 100 > 410
        
        if above_fl410
          east_alt = [45, 49, 53, 57, 61]
          west_alt = [43, 47, 51, 55, 59]
          
          east_valid = (is_north_east && east_alt.include?(cruise_stripped))
          west_valid = ((not is_north_east) && west_alt.include?(cruise_stripped))
          
          return true if east_valid || west_valid
        else
          return true if
            (is_north_east && cruise_stripped.odd?) ||
            ((not is_north_east) && cruise_stripped.even?)
        end
          
      when :VFR
      end
      
      false
    end
    
    # Cruising altitude.
    # Can accept a standard cruising altitude (33000) or flight level (FL370).
    def cruise=(value)
      # Strip letters from the cruising altitude.
      v = value.to_s.gsub(/[a-zA-Z]/, '').to_i
      
      # Append two zeros if the altitude is a flight level (three digits).
      v *= 100 if v < 1000
      
      @cruise = v
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

Route:      #{@route}

Cruise:     #{@cruise}
Scratchpad: #{@scratchpad}
Squawk:     #{@squawk}

Remarks:    #{@remarks}
EOS
    end
    
  end
end