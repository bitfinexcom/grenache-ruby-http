module Grenache
  class Http
    class HttpClient
      include HTTParty
      ssl_version :SSLv23

      def initialize config
        @config = config
      end

      def request uri, body
        options = {body: body}
        options[:timeout] = timeout  if timeout

        if tls?
          options[:pkcs12]      = File.open(pem)
          options[:ssl_ca_file] = ssl_ca_file
          options[:verify]      = verify
        end

        self.class.post uri, options
      end

      private

      def verify
        @config.reject_unauthorized
      end

      def tls?
        !! @config.cert_pem
      end

      def pem
        @config.cert_pem
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
