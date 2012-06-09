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
  
  def self.listen(host, port, &block)
    instance_eval &block
    puts "[listen] #{host}:#{port}"
    EventMachine::run {
      EventMachine::start_server host, port, Tecepe::Connection
    }
  end
  
  def self.clear_handlers
    @events = {}
  end
end