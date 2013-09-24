# Validate a flight plan for a clearance request.

require 'rautomation'
require 'launchy'
require 'net/http'
require 'ostruct'

@aclog_path = 'C:\Users\Alex\Documents\VRC\acinfo.txt'

# Get window handles.
vrc_win         = RAutomation::Window.new title: /VRC.*Connected to server:/
flight_plan_win = RAutomation::Window.new title: /Flight Plan - /
terminal_win    = RAutomation::Window.new title: /\\cmd.exe/

cmd = vrc_win.text_fields[0]
selected_aircraft = vrc_win.text_fields[1].value

exit unless selected_aircraft.length > 0

# Store the current text in the command bar.
prev_cmd = cmd.value

# Retrieve the flight plan.
cmd.set ".ss #{selected_aircraft}"
cmd.send_keys :return

# Retrieve the aircraft info.
cmd.set ".acinfo #{selected_aircraft}"
cmd.send_keys :return

# Dump the aircraft info to a log for processing.
cmd.set ".log acinfo.txt"
cmd.send_keys :return

# Restore any previous text in the command bar.
cmd.set prev_cmd

terminal_win.activate

#--------------------------------------------#
#  STAY OUT OF THE USER'S WAY AT THIS POINT  #
#--------------------------------------------#

# PROCESS DATA

flight_plan = OpenStruct.new \
  callsign:     flight_plan_win.text_fields[0].value,
  aircraft:     flight_plan_win.text_fields[1].value,
  flight_rules: '',
  depart:       flight_plan_win.text_fields[2].value,
  arrive:       flight_plan_win.text_fields[3].value,
  alternate:    flight_plan_win.text_fields[4].value,
  cruise:       flight_plan_win.text_fields[5].value,
  scratchpad:   flight_plan_win.text_fields[6].value,
  squawk:       flight_plan_win.text_fields[7].value,
  route:        flight_plan_win.text_fields[8].value,
  remarks:      flight_plan_win.text_fields[9].value,
  acinfo:       '', # Load from log file.
  dest_name:    ''  # Load from AirNav.


# Launch web page with airport heading.
heading_thread = Thread.new do
  Launchy.open "http://www6.landings.com/cgi-bin/nph-dist_apt?airport1=#{flight_plan.depart.downcase}&airport2=#{flight_plan.arrive.downcase}"
end

# Search for the destination airport name.
airport_thread = Thread.new do
  uri = URI "http://www.airnav.com/airport/#{flight_plan.arrive.strip}"
  begin
    @airport_response = Net::HTTP.get_response uri
    
    @response.body.each_line do |line|
      l = line.scan %r{(?i:<title>)(.*)(?i:</title>)}
      
      if l.count > 0
        flight_plan.dest_name = l.flatten.first
        break
      end
    end
  rescue
    # Can't find airport -- open it in a web search.
    Launchy.open "https://www.google.com/#q=#{flight_plan.arrive}+airport"
  end
end

heading_thread.join
airport_thread.join

aclog = File.open(@aclog_path).read

# Render data.
puts '------------------------------------------------------------'
puts flight_plan_win.title
puts ''

puts "Callsign:  #{flight_plan.callsign}"
puts "A/C Type:  #{flight_plan.aircraft}"
puts "Depart:    #{flight_plan.depart}"
puts "Arrive:    #{flight_plan.arrive} :: #{flight_plan.dest_name}"
puts "Alternate: #{flight_plan.alternate}"
puts "Route:     #{flight_plan.route}"
puts "Cruse:     #{flight_plan.cruise}"
puts "Squawk:    #{flight_plan.squawk}"
puts "Remarks:   #{flight_plan.remarks}"
puts '------------------------------------------------------------'
((aclog.lines.count - 4)..(aclog.lines.count - 1))
  .each {|i| puts aclog.lines[i] unless aclog.lines[i].nil?}
puts '------------------------------------------------------------'
