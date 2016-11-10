require 'grenahce-ruby-http'

Grenache::Base.configure do |conf|
   conf.grape_address = "http://127.0.0.1:40002/"
end

c = Grenache::Http.new
start_time = Time.now

10.times do |n|
 resp = c.request("test","world #{n}")
 puts resp
end

puts "Total Time: #{Time.now - start_time}"
