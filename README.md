# Tecepe

Launch small (evented) TCP JSON services on a given host:port

## Installation

Add this line to your application's Gemfile:

    gem 'tecepe'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install tecepe

## Usage

```ruby
Worker.listen("localhost", 5555) do
  
  on 'perms' do |payload|
    redis.smember("permissions:#{payload['user_id']}", payload['product_id']) do |r|
      reply allowed: r
    end
  end

end
```
In reality you would do some more computation than just proxying Redis!

## UDP

You can use UDP as your daemon's transport (instead of TCP). This is useful for non-blocking, fire-and-forget requests such as stats collectors or logging.

```ruby
Worker.udp("localhost", 5555) do
  
  on 'track' do |payload|
    redis.incrby payload['tracking_name'], 1
  end

end
```

## Clients

This is simple enough that it should be easy to write clients in different langs/stacks. See lib/tecepe/blocking_client.rb for a reference implementation of a TCP client with retry-on-disconnection.

```ruby
PEMISSIONS_SERVICE = Tecepe::BlockingClient.new('localhost', 5555)

PEMISSIONS_SERVICE.call 'perms', user_id: current_user.id, @product.id # true/false
```

UDP clients in Ruby are as easy as

```ruby
require 'socket'
client = UDPSocket.new

client.send JSON.generate(payload), 0, host, port
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
