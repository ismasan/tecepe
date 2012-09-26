require "tecepe/version"
require "tecepe/connection"

module Tecepe
  def self.events
    @events ||= {}
  end
  
  def self.on(event, &handler)
    events[event] = handler
  end
  
  def self.dispatch(connection, event_name, payload)
    if handler = events[event_name]
      connection.instance_exec payload, &handler
    else
      connection.send_error "No handler for event #{event_name}"
    end
  end
  
  def self.tcp(host, port, &block)
    listen host, port, :tcp, &block
  end
  
  def self.udp(host, port, &block)
    listen host, port, :udp, &block
  end
  
  def self.listen(host, port, type = :tcp, &block)
    raise "Available socket types are :tcp and :udp" unless [:tcp, :udp].include?(type)
    instance_eval &block
    puts "[listen #{type}] #{host}:#{port}"
    EventMachine::run {
      if type == :tcp
        require "tecepe/tcp_connection"
        EventMachine::start_server host, port, Tecepe::TCPConnection
      else
        require "tecepe/udp_connection"
        EventMachine::open_datagram_socket host, port, Tecepe::UDPConnection
      end
    }
  end
  
  def self.clear_handlers
    @events = {}
  end
end