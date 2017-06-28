require_relative '../lib/grenache-ruby-http.rb'

c = Grenache::Http.new(grape_address: "http://127.0.0.1:40002/",
                       cert_p12: File.expand_path('.') + "/ssl/client1.p12",
                       ca: File.expand_path('.') + "/ssl/ca.crt")

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
