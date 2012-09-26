module Tecepe
  
  module TCPConnection
    
    include Connection
    
    HEARTBEAT = 5.freeze
    
    def post_init
      @heartbeat = setup_heartbeat
      super
    end

    def unbind
      @heartbeat.cancel
      super
    end

    private

    def setup_heartbeat
      EventMachine::PeriodicTimer.new(HEARTBEAT) do
        log :heartbeat
        send_data ''
      end
    end
  end
  
end