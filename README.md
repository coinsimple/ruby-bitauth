# Bitauth

BitAuth is a way to do secure, passwordless authentication proposed by Bitpay using the same elliptic-curve cryptography as Bitcoin

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'bitauth'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install bitauth

## Usage

To Generate a new Key pair you can just instantiate a new BitAuth instance with no parameters:

```ruby
require 'bitauth'

bitauth = BitAuth.new

bitauth.sin
bitauth.public_key
bitauth.private_key
```

To sign a message after that you can just call `sign`:

```ruby
bitauth = BitAuth.new private_key: "HEX_PRIVATE_KEY"

signature = bitauth.sign("data")
```

You can then verify the message using just the public key:

```ruby
bitauth = BitAuth.new public_key: "HEX_PUBLIC_KEY"

bitauth.verify("data", "signature")
```

## Example

```ruby
require 'bitauth'

bitauth = BitAuth.new

data = '{"id":10, "message": "Demo Text"}'
signature = bitauth.sign(data)

if bitauth.verify(data, signature)
  puts "Everything checks out"
end
```

## Contributing

1. Fork it ( https://github.com/gmanricks/BitAuth/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
