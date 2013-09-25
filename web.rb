require 'net/http'
require 'pry'

# http://skyvector.com/airport/PDX
# http://www.airnav.com/airport/klax
t1 = Thread.new do
  uri = URI 'http://www.airnav.com/airport/klax'
  @response = Net::HTTP.get_response uri
end

t1.join

@response.body.each_line do |line|
  l = line.scan %r{(?i:<title>)(.*)(?i:</title>)}
  puts l.flatten.first if l.count > 0
end