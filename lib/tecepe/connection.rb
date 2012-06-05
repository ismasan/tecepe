require 'eventmachine'
require 'json'

module Tecepe
  
  class Connection < EventMachine::Connection
    
    HEARTBEAT = 5.freeze
    
    def post_init
      puts '[conn]'
      @heartbeat = setup_heartbeat
      super
    end

    def unbind
      puts '[bye]'
      @heartbeat.cancel
      super
    end

    def receive_data data
      puts "[rcvd] #{data}"
      if data =~ /quit/i
        close_connection_after_writing
      else
        begin
          json = JSON.parse(data)
          Tecepe.dispatch self, json['event'], json['payload']
        rescue JSON::ParserError => e
          send_error e.message
        rescue Encoding::UndefinedConversionError => e
          send_error e.message
        end
      end
    end

    def reply(payload = {}, status = 1)
      json = JSON.generate(status: status, payload: payload)
      puts "[repl] #{json}"
      if error?
        puts "[error]"
      else
        send_data "#{json}\n"
      end
    end

    def send_error(msg)
      reply({message: msg}, -1)
    end

    private

    def setup_heartbeat
      EventMachine::PeriodicTimer.new(HEARTBEAT) do
        puts '[heartbeat]'
        send_data ''
      end
    end

  end
  
end