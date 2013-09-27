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
        puts 'No aircraft selected.'
        return
      end
      
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
      
      vrc.activate_terminal_window!
      
      puts '------------------------------------------------------------'
      puts @flight_plan
      puts ''
      puts "Heading: #{@flight_plan.heading} mag :: #{@flight_plan.depart.magnetic_to_true @flight_plan.heading} true"
      puts ''
      puts @flight_plan.aircraft.info
      puts '------------------------------------------------------------'
    end
    
  end
end