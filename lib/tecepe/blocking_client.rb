require 'socket'
require 'json'
require "timeout"

# Simple (blocking) client with basic reconnect functionality
# Some code taken from Redis client
# https://github.com/redis/redis-rb
#
# EXAMPLE:
# socket = Tecepe::BlockingClient.new('localhost', 5555)
# 
# 20.times do |i|
#   response = socket.call 'perms', user_id: 3          # Send request
#   puts "RESPONSE: #{response}"
# end
#
module Tecepe
  
  class BlockingClient

    def initialize(host, port, cid = Process.pid)
      @host, @port, @cid = host, port, cid
      @socket = nil
      @reconnect = true
      connect
    end

    def connected?
      !! @socket
    end

    def call(event_name, payload)
      json = JSON.generate(event: event_name, cid: @cid, payload: payload)
      ensure_connected do
        @socket.print json
        JSON.parse(@socket.gets)
      end
    end

    private

    def connect
      with_timeout 1 do
        @socket = TCPSocket.new(@host, @port)
        # @socket.setsockopt Socket::IPPROTO_TCP, Socket::TCP_NODELAY, 1
        puts "[open]"
      end
    end

    def disconnect
      return false unless connected?
      @socket.close
    rescue
    ensure
      puts "[close]"
      @socket = nil
    end

    def with_timeout(seconds, &block)
      Timeout.timeout(seconds, &block)
    end

    def ensure_connected(&block)
      tries = 0

      begin
        connect unless connected?
        tries += 1

        yield
      rescue Errno::ECONNRESET, Errno::EPIPE, Errno::ECONNABORTED, Errno::EBADF, Errno::EINVAL
        disconnect

        if tries < 2 && @reconnect
          retry
        else
          raise Errno::ECONNRESET
        end
      rescue Exception
        disconnect
        raise
      end
    end

  end
  
end