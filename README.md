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
  
  on 'perms' do |json|
    redis.smember("permissions:#{json['user_id']}", json['product_id']) do |r|
      reply allowed: r
    end
  end

end
```

In reality you would do some more computation than just proxying Redis!

## Clients

This is simple enough that it should be easy to write clients in different langs/stacks. See lib/tecepe/blocking_client.rb for a reference implementation.

```ruby
socket = Tecepe::BlockingClient.new('localhost', 5555)

20.times do |i|
  response = socket.call 'perms', user_id: 3          # Send request
  puts "RESPONSE: #{response}"
end
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
