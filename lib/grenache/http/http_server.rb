module Thin
  module Backends
    class Base
      attr_accessor :ca_cert
    end
  end

  class Connection < EventMachine::Connection
    def ssl_verify_peer cert
      client = OpenSSL::X509::Certificate.new cert
      store.verify client
    end


    private
    def store
       @store ||= OpenSSL::X509::Store.new.tap do |store|
         store.add_file backend.ca_cert
       end
    end
  end
end

