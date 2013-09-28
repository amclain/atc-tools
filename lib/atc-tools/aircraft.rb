module ATCTools
  class Aircraft
    # Raw data used to initialize the object,
    # typically from the VRC client.
    attr_reader   :raw
    # Full aircraft info string.
    attr_accessor :info
    # Aircraft code. The identifier that would be displayed
    # on the radar scope (B732 = Boeing 737-200).
    attr_reader   :code
    # Aircraft model number.
    attr_reader   :model
    # Aircraft equipment code.
    attr_reader   :equipment
    
    # Params:
    #   :info, :model, :code, :equipment
    #   -- See instance variables for descriptions.
    def initialize(aircraft_code = nil, **kvargs)
      @raw       = aircraft_code || kvargs.fetch(:code, '')
      @info      = kvargs.fetch :info, ''
      @model     = kvargs.fetch :model, ''
      
      params     = @raw.scan(%r{(?:([a-zA-Z]+)/)?(\w+)(?:/([a-zA-Z]+))?}).flatten
      
      @code      = kvargs.fetch(:code, nil) || params[1] || ''
      @equipment = kvargs.fetch(:equipment, nil) || params[2] || ''
    end
    
    # Returns @raw.
    def to_s
      @raw
    end
    
  end
end