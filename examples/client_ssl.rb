require_relative '../lib/grenache-ruby-http.rb'

c = Grenache::Http.new(grape_address: "http://127.0.0.1:40002/",
                       key:  File.expand_path('.') + "/ssl/client1-key.pem",
                       cert_pem: File.expand_path('.') + "/ssl/client1-crt.pem",
                       ca: File.expand_path('.') + "/ssl/ca-crt.pem")

start_time = Time.now

10.times do |n|
  err,resp = c.request("rpc_test","world #{n}")
  if !err
    puts "response: #{resp}"
  else
    puts "ERROR: #{err}"
  end
end

puts "Total Time: #{Time.now - start_time}"
