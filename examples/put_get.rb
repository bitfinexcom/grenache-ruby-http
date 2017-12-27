require_relative '../lib/grenache-ruby-http.rb'

c = Grenache::Http.new grape_address: "http://127.0.0.1:30001/"

err,res_hash = c.put({ "v" => "pineapple test" })
if !err

  puts "response, hash is: #{res_hash}"
else
  puts err
end

err,resp = c.get(res_hash)
if !err
  puts "response of #{res_hash}: #{resp}"
else
  puts err
end
