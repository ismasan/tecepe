$:.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'tecepe'

Tecepe.tcp("localhost", 5555) do
  
  on 'perms' do |json|
    EventMachine::Timer.new(json['delay'].to_f) do
      reply message: ">>>you sent: #{json}\n"
    end
  end

end