$:.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'tecepe/blocking_client'

socket = Tecepe::BlockingClient.new('localhost', 5555)

delay = ARGV[0]

m = <<-eos
Hello this is a text

with line changes
And more
eos

20.times do |i|
  response = socket.call 'perms', delay: delay.to_f , m: m        # Send request
  puts "RESPONSE: #{response.class.name} - #{response}"
end