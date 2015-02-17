# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'bitauth'

Gem::Specification.new do |spec|
  spec.name          = "BitAuth"
  spec.version       = BitAuth::VERSION
  spec.authors       = ["Gabriel Manricks"]
  spec.email         = ["gmanricks@gmail.com"]
  spec.summary       = "Passwordless authentication protocol based on the same cryptography used in the Bitcoin protocol"
  spec.description   = "BitAuth is a way to do secure, passwordless authentication proposed by Bitpay using the same elliptic-curve cryptography as Bitcoin"
  spec.homepage      = "https://github.com/gmanricks/BitAuth"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake", "~> 10.0"
end
