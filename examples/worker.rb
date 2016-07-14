require 'thin'
require 'grenache-ruby-base'
require_relative "../lib/grenache/base.rb"

Grenache::Base.configure do |conf|
   conf.grape_address = "http://127.0.0.1:30002"
end

EM.run do

  Signal.trap("INT")  { EventMachine.stop }
  Signal.trap("TERM") { EventMachine.stop }

  c = Grenache::Base.new

  c.listen('test',5004) do |env|
    [200,nil,'hello world']
  end

end
