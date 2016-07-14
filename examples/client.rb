require 'grenache-ruby-base'

require_relative "../lib/grenache/base.rb"

Grenache::Base.configure do |conf|
   conf.grape_address = "http://127.0.0.1:30002"
end

c = Grenache::Base.new
start_time = Time.now

100.times do |n|
  c.request("test","world #{n}")
end

puts "Total Time: #{Time.now - start_time}"

