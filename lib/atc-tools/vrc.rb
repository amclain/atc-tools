require 'rautomation'

module ATCTools
  # A class for interfacing with the Virtual Radar Client application.
  # http://www1.metacraft.com/VRC/
  class VRC
    
    # Extracts the flight plan of the selected aircraft.
    def extract_flight_plan
    end
    
    # Extracts the callsign of the selected aircraft.
    # Returns an empty string if no aircraft is selected.
    def extract_selected_aircraft
    end
    
    # True if an aircraft is selected.
    def aircraft_selected?
    end
    
  end
end