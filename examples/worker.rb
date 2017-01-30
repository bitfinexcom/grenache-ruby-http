require_relative '../lib/grenache-ruby-http.rb'

Grenache::Http.configure do |conf|
   conf.grape_address = "http://127.0.0.1:40002/"
end

EM.run do

  Signal.trap("INT")  { EventMachine.stop }
  Signal.trap("TERM") { EventMachine.stop }

  c = Grenache::Http.new

  c.listen('test', 5004) do |env|
    body = env['rack.input'].read
    req = Grenache::Message.parse(body)
    "hello #{req.payload}"
  end

end
