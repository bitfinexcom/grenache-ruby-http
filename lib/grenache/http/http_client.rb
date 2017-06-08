module Grenache
  class Http
    class HttpClient
      include HTTParty

      def initialize config
        @config = config
      end

      def request uri, body
        options = {body: body}
        options[:timeout] = timeout  if timeout

        if tls?
          options[:pem]         = pem
          options[:ssl_ca_file] = ssl_ca_file
        end

        self.class.post uri, options
      end

      private

      def tls?
        !! @config.cert_pem
      end

      def pem
        cert = File.read @config.cert_pem
        key = File.read @config.key
        cert + key
      end

      def ssl_ca_file
        @config.ca
      end

      def timeout
        @config.service_timeout
      end
    end
  end
end
