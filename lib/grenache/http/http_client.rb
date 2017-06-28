module Grenache
  class Http
    class HttpClient
      include HTTParty

      def initialize config
        @config = config
      end

      def request uri, body, params = {}
        uri = URI.parse(uri)
        options = {body: body}

        if params[:timeout]
          options[:timeout] = params[:timeout]
        else
          options[:timeout] = timeout if timeout
        end

        if pem? or p12?
          uri.scheme = "https"
        end

        if pem?
          options[:pem]          = pem
          options[:pem_password] = @config.cert_pem_password
          options[:ssl_ca_file]  = ssl_ca_file
        elsif p12?
          options[:p12]          = IO.binread @config.cert_p12
          options[:p12_password] = @config.cert_p12_password
          options[:ssl_ca_file]  = ssl_ca_file
        end

        self.class.post uri.to_s, options
      end

      private

      def pem?
        !! @config.cert_pem
      end

      def p12?
        !! @config.cert_p12
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
