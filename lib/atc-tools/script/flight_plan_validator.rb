require 'launchy'
require 'atc-tools/vrc'
require 'atc-tools/flight_plan'

module ATCTools
  # Script that extracts a flight plan from VRC.
  class FlightPlanValidator
    private_class_method :new
    
    def self.flight_plan
      @flight_plan
    end
    
    # Note: Executing this script will call commands in
    # the VRC client and will interfere with the user.
    def self.run
      vrc = ATCTools::VRC.new
      
      begin
        @flight_plan = vrc.selected_flight_plan!
      rescue ATCTools::NoAircraftSelectedError
        return 'No aircraft selected.'
      end
      
      vrc.activate_terminal_window!
      
      heading_thread = Thread.new do
        begin
          @flight_plan.heading
        rescue ATCTools::HeadingDiscoveryError
          Launchy.open @flight_plan.depart.heading_uri
        end
      end
      
      airport_name_thread = Thread.new do
        begin
          @flight_plan.arrive.name
        rescue ATCTools::NameDiscoveryError
          Launchy.open "https://www.google.com/#q=#{@flight_plan.arrive.upcase}+airport"
        end
      end
      
      heading_thread.join
      airport_name_thread.join
      
      output = []
      
      output << '------------------------------------------------------------'
      output << vrc.flight_plan_title
      output << ''
      output << @flight_plan.to_s.split("\n")
      output << ''
      output << ''
      output << "Alt Valid?  #{(@flight_plan.altitude_valid?) ? 'Yes' : '-NO-'}"
      output << "Heading:    #{@flight_plan.heading} mag :: #{@flight_plan.depart.magnetic_to_true @flight_plan.heading} true"
      output << ''
      output << @flight_plan.aircraft.info.split(' - ').join("\n").strip
      output << '------------------------------------------------------------'
      
      text = output.join("\n")
    end
    
  end
end