
module Grenache
  class Http < Grenache::Base
    def listen(key, port,  opts={}, &block)
      start_http_service(port,&block)

      announce(key, port, opts) do |res|
        puts "#{key} announced #{res}"
      end
    end

    def start_http_service(port, &block)
      EM.defer {
        app = -> (env) {
          req = Message.parse(env['rack.input'].read)
          resp = block.call(req)
          [200,nil, Message.response_to(req,resp).to_json]
        }
        server = Thin::Server.start('0.0.0.0', port, app, {signals: false})
      }
    end

    def request(key, payload)
      services = lookup(key)
      if services.size > 0
        json = Message.req(key,payload).to_json
        service = services.sample.sub("tcp://","http://")
        service.prepend("http://") unless service.start_with?("http://")
        resp = HTTParty.post(service,{body: json})
        return [false, Message.parse(resp.body)]
      else
        return ["NoPeerFound",nil]
      end
    rescue Exception => e
      return [e, nil]
    end
  end
end
