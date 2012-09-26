module Tecepe
  
  module UDPConnection
    
    include Connection

    # UDP socket does not respond
    def send_data(*args)
      log :send_data, args.inspect
    end
    
  end
  
end