require_relative '../lib/grenache-ruby-http.rb'

Grenache::Http.configure do |conf|
   conf.grape_address = "http://127.0.0.1:40002/"
   conf.key = File.expand_path('.') + "/ssl/server-key.pem"
   conf.cert_pem = File.expand_path('.') + "/ssl/server-crt.pem"
   conf.ca = File.expand_path('.') + "/ssl/ca-crt.pem"
end

EM.run do

  Signal.trap("INT")  { EventMachine.stop }
  Signal.trap("TERM") { EventMachine.stop }

  c = Grenache::Http.new

  c.listen('rpc_test', 5004) do |msg, fingerprint|
    #[StandardError.new("Error!"),"hello #{msg.payload}"]
    puts fingerprint
    [nil,"hello #{msg.payload}"]
  end

end
