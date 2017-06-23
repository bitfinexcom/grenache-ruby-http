module Grenache
  class Http < Grenache::Base

    default_conf do |conf|
      conf.thin_threaded = true
      conf.threadpool_size = 10
      conf.verify_mode = Grenache::SSL_VERIFY_PEER
    end

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
          fingerprint = extract_fingerprint(env['rack.peer_cert'])
          e, payload = block.call(req, fingerprint)
          err = e.kind_of?(Exception) ? e.message : e
          [200,nil, ServiceMessage.new(payload, err, req.rid).to_json]
        }
        server = Thin::Server.new config.service_host, port, {signals: false}, app

        if config.thin_threaded
          server.threaded = true
          server.threadpool_size = config.thin_threadpool_size
        end

        if tls?
          server.ssl = true
          server.ssl_options = {
            private_key_file: config.key,
            cert_chain_file: config.cert_pem,
            verify_peer: true
          }
          server.backend.ca_cert = File.read config.ca
        end
        server.start
      }
    end

    def request(key, payload, params={})
      services = lookup(key)
      if services && services.size > 0
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

    def tls?
      !! config.cert_pem
    end

    def extract_fingerprint cert
      return "" unless cert
      cert = OpenSSL::X509::Certificate.new cert
      OpenSSL::Digest::SHA1.new(cert.to_der).to_s
    end

    def http_client
      @http_client ||= HttpClient.new(config)
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
  end
end
