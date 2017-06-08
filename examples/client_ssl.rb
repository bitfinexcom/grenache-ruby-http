require_relative '../lib/grenache-ruby-http.rb'

Grenache::Http.configure do |conf|
   conf.grape_address = "http://127.0.0.1:40002/"
   conf.key = File.expand_path('.') + "/ssl/clientkey.pem"
   conf.cert_pem = File.expand_path('.') + "/ssl/clientreq.pem"
end

c = Grenache::Http.new
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
