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
          req = ServiceMessage.parse(env['rack.input'].read)
          e, payload = block.call(req)
          err = e.kind_of?(Exception) ? e.message : e
          [200,nil, ServiceMessage.new(payload, err, req.rid).to_json]
        }
        server = Thin::Server.start('0.0.0.0', port, app, {signals: false})
      }
    end

    def request(key, payload)
      services = lookup(key)
      if services.size > 0
        json = ServiceMessage.new(payload).to_json
        service = services.sample.sub("tcp://","http://")
        service.prepend("http://") unless service.start_with?("http://")
        resp = HTTParty.post(service,{body: json})
        msg = ServiceMessage.parse(resp.body)
        return [msg.err, msg.payload]
      else
        return ["NoPeerFound",nil]
      end
    rescue Exception => e
      return [e, nil]
    end
  end
end
