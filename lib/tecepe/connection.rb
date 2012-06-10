require 'eventmachine'
require 'json'

module Tecepe
  
  module Connection
    
    HEARTBEAT = 5.freeze
    
    def post_init
      @heartbeat = setup_heartbeat
      @cid = nil
      log :conn, signature
      super
    end

    def unbind
      log :bye
      @heartbeat.cancel
      super
    end
    
    def receive_data data
      log :data, data
      (@buffer ||= BufferedTokenizer.new).extract(data).each do |line|
        receive_line(line)
      end
    end
    
    def receive_line data
       begin
         json = JSON.parse(data)
         @cid = json['cid']
         log :rcvd, json['payload']
         Tecepe.dispatch self, json['event'], json['payload']
       rescue JSON::ParserError => e
         send_error e.message
       rescue Encoding::UndefinedConversionError => e
         send_error e.message
       end
    end

    def reply(payload = {}, status = 1)
      json = JSON.generate(status: status, payload: payload)
      log :repl, json
      if error?
        log :error
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
        log :heartbeat
        send_data ''
      end
    end
    
    def log(key, msg = '')
      puts "#{Process.pid} [#{key} #{@cid}] #{msg}"
    end
  end
  
end