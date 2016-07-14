module Grenache
  class Base
    def listen(key, port,  opts={}, &block)
      EM.defer {
        app = -> (env) {
          block.call(env)
        }
        server = Thin::Server.start('0.0.0.0', port, app, {signals: false})
      }

      announce(key, port, opts) do |res|
        puts "#{key} announced #{res}"
      end
    end

    def request(key, payload, &block)
      services = lookup(key)
      res = HTTPClient.new.post(services).body
    end
  end
end
