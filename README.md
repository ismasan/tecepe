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
    EventMachine::Timer.new(json['delay'].to_f) do
      reply message: ">>>you sent: #{json}\n"
    end
  end

end
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
