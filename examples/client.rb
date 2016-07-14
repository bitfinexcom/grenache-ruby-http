require 'thin'
require 'pry'
require 'grenache-ruby-base'
require 'httpclient'

require_relative "../lib/grenache/base.rb"
require 'benchmark'

Grenache::Base.configure do |conf|
   conf.grape_address = "http://127.0.0.1:30002"
end

c = Grenache::Base.new
tot = 0
start_time = Time.now

100.times do |n|
  c.request("test","world #{n}")
end

puts "Total Time: #{Time.now - start_time}"

