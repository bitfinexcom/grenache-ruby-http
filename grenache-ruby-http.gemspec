# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'grenache/http/version'

Gem::Specification.new do |spec|
  spec.name          = "grenache-ruby-http"
  spec.version       = Grenache::HTTP::VERSION
  spec.email         = ["info@bitfinex.com"]
  spec.authors       = "Bitfinex <info@bitfinex.com>"

  spec.summary       = %q{http client for Grenache}
  spec.homepage      = "https://github.com/bitfinexcom/grenache-ruby-http"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "eventmachine", "~> 1.2"
  spec.add_runtime_dependency "faye-websocket", "~> 0.10"
  spec.add_runtime_dependency "grenache-ruby-base", "~> 0.2.11"
  spec.add_runtime_dependency "httparty", "~> 0.14.0"
  spec.add_runtime_dependency "oj", "~> 2.18"
  spec.add_runtime_dependency "thin", "~> 1.7"

  spec.add_development_dependency "rspec", "~> 3.5.0"
end
