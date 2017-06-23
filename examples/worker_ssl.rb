require_relative '../lib/grenache-ruby-http.rb'

EM.run do

  Signal.trap("INT")  { EventMachine.stop }
  Signal.trap("TERM") { EventMachine.stop }

c = Grenache::Http.new(grape_address: "http://127.0.0.1:40002/",
                       key:  File.expand_path('.') + "/ssl/server-key.pem",
                       cert_pem: File.expand_path('.') + "/ssl/server-chain.pem",
                       ca: File.expand_path('.') + "/ssl/ca-crt.pem",
                       service_host: "localhost")

  c.listen('rpc_test', 5004) do |msg, fingerprint|
    #[StandardError.new("Error!"),"hello #{msg.payload}"]
    puts "certificate fingerprint #{fingerprint}"
    [nil,"hello #{msg.payload}"]
  end

end
