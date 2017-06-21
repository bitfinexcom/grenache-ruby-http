require_relative '../lib/grenache-ruby-http.rb'

# This is another way to set a configuration:
#
# Grenache::Http.configure do |conf|
#   conf.grape_address = "http://127.0.0.1:40002/"
# end

EM.run do

  Signal.trap("INT")  { EventMachine.stop }
  Signal.trap("TERM") { EventMachine.stop }

  c = Grenache::Http.new grape_address: "http://127.0.0.1:40002/"

  c.listen('rpc_test', 5004) do |msg|
    #[StandardError.new("Error!"),"hello #{msg.payload}"]
    [nil, "hello #{msg.payload}"]
  end

end
