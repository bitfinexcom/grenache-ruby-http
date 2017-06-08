require "puma/events"

module Grenache

  class Http < Grenache::Base

    def listen(key, port,  opts={}, &block)
      start_http_service(port,&block)

      announce(key, port, opts) do |res|
        puts "#{key} announced #{res}"
      end
    end

   def start_http_service(port, &block)
      app = -> (env) {
        req = ServiceMessage.parse(env['rack.input'].read)
        fingerprint = extract_fingerprint(env['puma.peercert'])
        e, payload = block.call(req, fingerprint)
        err = e.kind_of?(Exception) ? e.message : e
        [200,[], [ServiceMessage.new(payload, err, req.rid).to_json]]
      }

      event = Puma::Events.new $stdout, $stderr
      server = Puma::Server.new app, event
      host = config.service_host

      if tls?
        ctx = Puma::MiniSSL::Context.new
        ctx.key = config.key
        ctx.cert = config.cert_pem
        ctx.ca = config.ca
        ctx.verify_mode = config.verify_mode

        server.add_ssl_listener host, port, ctx
      else
        server.add_tcp_listener host, port
      end

      puts "starting server on port #{port}"
      server.run
    end

    def request(key, payload, params = {})
      services = lookup(key)
      if services.size > 0
        json = ServiceMessage.new(payload,key).to_json
        service = get_random_service services
        resp = http_client.request service, json, params
        msg = ServiceMessage.parse(resp.body)
        return [msg.err, msg.payload]
      else
        return ["NoPeerFound",nil]
      end
    rescue Exception => e
      return [e, nil]
    end

    private

    def extract_fingerprint cert
      return "" unless cert
      cert = OpenSSL::X509::Certificate.new cert
      OpenSSL::Digest::SHA1.new(cert.to_der).to_s
    end

    def tls?
      !! config.cert_pem
    end

    def get_random_service services
      service = services.sample
      service.sub!("tcp://","https://")
      if tls?
        service.prepend("https://") unless service.start_with?("https://")
      else
        service.prepend("http://") unless service.start_with?("http://")
      end
      service
    end

    def http_client
      @http_client ||= HttpClient.new(config)
    end
  end
end
