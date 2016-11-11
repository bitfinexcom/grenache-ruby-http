require 'thin'
require 'grenache-ruby-http'

Grenache::Base.configure do |conf|
   conf.grape_address = "http://127.0.0.1:40002/"
end

EM.run do

  Signal.trap("INT")  { EventMachine.stop }
  Signal.trap("TERM") { EventMachine.stop }

  c = Grenache::Http.new

  c.listen('test',5003) do |env|
    req = Oj.load(env['rack.input'].read)
    [200,nil,"hello #{req}"]
  end

end
