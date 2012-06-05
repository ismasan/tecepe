$:.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'tecepe/blocking_client'

socket = Tecepe::BlockingClient.new('localhost', 5555)

delay = ARGV[0]

20.times do |i|
  response = socket.call 'perms', delay: delay.to_f         # Send request
  puts "RESPONSE: #{response}"
end