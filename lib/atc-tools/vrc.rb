require 'rautomation'
require 'atc-tools/flight_plan'
require 'atc-tools/aircraft'

module ATCTools
  class NoAircraftSelectedError < StandardError; end
  
  # A class for interfacing with the Virtual Radar Client application.
  # http://www1.metacraft.com/VRC/
  class VRC
    # VRC log path for exporting aircraft info.
    attr_accessor :aclog_path
    attr_reader   :selected_aircraft
    
    def initialize(**kvargs)
      @aclog_path = kvargs.fetch :aclog_path, File.expand_path('Documents/VRC/acinfo.txt', '~')
      
      @selected_aircraft = ''
      
      #Window handles.
      @vrc_win         = RAutomation::Window.new title: /VRC.*Connected to server:/
      @flight_plan_win = RAutomation::Window.new title: /Flight Plan - /
      @terminal_win    = RAutomation::Window.new title: /\\cmd.exe/
      
      @command_win     = @vrc_win.text_fields[0]
      @callsign_win    = @vrc_win.text_fields[1]
    end
    
    # Extracts the flight plan of the selected aircraft.
    #
    # MAKE SURE THE EXTRACTED CALLSIGN IS UP TO DATE BEFORE
    # CALLING THIS METHOD.
    def extract_flight_plan
      raise ATCTools::NoAircraftSelectedError, "No aircraft selected." \
        if @selected_aircraft.empty?
      
      execute_command ".ss #{@selected_aircraft}"
      
      flight_plan = ATCTools::FlightPlan.new \
        callsign:   @selected_aircraft,
        aircraft:   ATCTools::Aircraft.new(@flight_plan_win.text_fields[1].value),
        rules:      '',
        depart:     ATCTools::Airport.new(@flight_plan_win.text_fields[2].value),
        arrive:     ATCTools::Airport.new(@flight_plan_win.text_fields[3].value),
        alternate:  ATCTools::Airport.new(@flight_plan_win.text_fields[4].value),
        cruise:     @flight_plan_win.text_fields[5].value.to_i,
        scratchpad: @flight_plan_win.text_fields[6].value.strip,
        squawk:     @flight_plan_win.text_fields[7].value.strip,
        route:      @flight_plan_win.text_fields[8].value.strip,
        remarks:    @flight_plan_win.text_fields[9].value.strip
    end
    
    # Extracts the callsign of the selected aircraft.
    # Returns an empty string if no aircraft is selected.
    def extract_selected_aircraft
      @selected_aircraft = @callsign_win.value.strip
    end
    
    # True if an aircraft is selected.
    def aircraft_selected?
      selection_empty = extract_selected_aircraft.empty?
      @selected_aircraft = '' if selection_empty
      not selection_empty
    end
    
    # Extracts the aircraft info for the selected aircraft.
    #
    # MAKE SURE THE EXTRACTED CALLSIGN IS UP TO DATE BEFORE
    # CALLING THIS METHOD.
    def extract_aircraft_info
      raise ATCTools::NoAircraftSelectedError, "No aircraft selected." if @selected_aircraft.empty?
      
      # ---------------------------
      # TODO: 
      # ---------------------------
    end
    
    # Extract the text from the command line.
    def extract_command
      @command_win.value
    end
    
    # Execute a command in the VRC client.
    # Preserves partially-entered commands in the text box.
    def execute_command(cmd)
      old_cmd = extract_command
      execute_command! cmd
      @command_win.set old_cmd
    end
    
    # Execute a command in the VRC client, overwriting any
    # partially-entered command in the text box.
    def execute_command!(cmd)
      @command_win.set cmd
      @command_win.send_keys :return
    end
    
    # Activate the VRC window, bringing it to the foreground.
    def activate_vrc_window
      @vrc_win.activate
    end
    
    # Activate the terminal (command line) window, bringing
    # it to the foreground.
    def activate_terminal_window
      @terminal_win.activate
    end
    
  end
end