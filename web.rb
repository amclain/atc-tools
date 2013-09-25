require 'net/http'
require 'pry'

# http://skyvector.com/airport/PDX
# http://www.airnav.com/airport/klax
# http://www6.landings.com/cgi-bin/nph-dist_apt?airport1=kpdx&airport2=klax
t1 = Thread.new do
  uri = URI 'http://www6.landings.com/cgi-bin/nph-dist_apt?airport1=kpdx&airport2=klax'
  @response = Net::HTTP.get uri
end

t1.join

r = @response.scan /(?:heading:)\s*([\d\.]+)\s+/
variation = 16.0

true_hdg = (r.count > 0) ? r.flatten.first.to_f : nil
mag_hdg = true_hdg - variation

puts "True: #{true_hdg}"
puts "Mag:  #{mag_hdg}"
puts "Var:  #{variation}"
