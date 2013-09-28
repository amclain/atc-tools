require 'rautomation'
require 'atc-tools/flight_plan'
require 'atc-tools/aircraft'

module ATCTools
  class NoAircraftSelectedError < StandardError; end
  
  # A class for interfacing with the Virtual Radar Client application.
  # http://www1.metacraft.com/VRC/
  #
  # Methods with a bang (!) at the end manipulate the window and
  # could affect the user.
  class VRC
    # VRC log path for exporting aircraft info.
    attr_accessor :aclog_path
    
    # Params:
    #   :aclog_path - Location of the VRC log dump for the aircraft info query.
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
    
    # Title of the VRC flight plan window.
    # This includes the pilot's callsign and real name.
    def flight_plan_title
      @flight_plan_win.title
    end
    
    # Extracts the flight plan of the selected aircraft.
    def selected_flight_plan!
      raise ATCTools::NoAircraftSelectedError, "No aircraft selected." \
        unless aircraft_selected?
      
      execute_command ".ss #{@selected_aircraft}"
      
      flight_plan = ATCTools::FlightPlan.new \
        callsign:   @selected_aircraft,
        aircraft:   ATCTools::Aircraft.new(
                      @flight_plan_win.text_fields[1].value,
                      info: selected_aircraft_info!
                    ),
        rules:      (RAutomation::Adapter::Win32::SelectList.new @flight_plan_win, index: 0)
                      .value.upcase.to_sym,
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
    def selected_aircraft
      @selected_aircraft = @callsign_win.value.strip
    end
    
    # True if an aircraft is selected.
    def aircraft_selected?
      selection_empty = selected_aircraft.empty?
      @selected_aircraft = '' if selection_empty
      not selection_empty
    end
    
    # Extracts the aircraft info for the selected aircraft.
    def selected_aircraft_info!
      # --------------------------------------------------------------------------
      # TODO: Prompt for an aircraft model as the input and use .typeinfo instead.
      #       This way it can return info for cached aircraft.
      # --------------------------------------------------------------------------
      
      raise ATCTools::NoAircraftSelectedError, "No aircraft selected." \
        unless aircraft_selected?
      
      # ---------------------------
      # TODO: 
      # ---------------------------
      
      # Retrieve the aircraft info.
      execute_command ".acinfo #{@selected_aircraft}"

      # Dump the aircraft info to a log for processing.
      execute_command ".log #{File.basename @aclog_path}"
      
      # Process aircraft info.
      aclog = ''
      result = ''
      attempts = 0
      
      while attempts < 5
        aclog_exists = File.exists? @aclog_path
        break if aclog_exists
        
        attempts += 1
        sleep 0.5
      end
      
      if aclog_exists
        aclog = File.open(@aclog_path).read
        
        # Only keep the last few lines.
        # Reverse the lines so the latest one is first.
        aclog = aclog.lines[-6..-1].reverse.join
        
        aclog.each_line do |line|
          result = line.gsub /.*\s*(Aircraft info for \w*:\s*)/, '' if line.include? "Aircraft info for #{@selected_aircraft}"
          break if result
        end
        
        # ---------------
        # TODO: Implement
        # ---------------
        result = "Aircraft type code '#{'xxx'}' not found in database." if result.empty?
        
        # File.delete @aclog_path
      end
      
      result
    end
    
    # Extract the text from the command line.
    def command_line
      @command_win.value
    end
    
    # Execute a command in the VRC client.
    # Preserves partially-entered commands in the text box.
    def execute_command(cmd)
      old_cmd = command_line
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
    def activate_vrc_window!
      @vrc_win.activate
    end
    
    # Activate the terminal (command line) window, bringing
    # it to the foreground.
    def activate_terminal_window!
      @terminal_win.activate
    end
    
  end
end