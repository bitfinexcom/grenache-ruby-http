module Thin
  class Connection < EventMachine::Connection
    def ssl_verify_peer cert
      client = OpenSSL::X509::Certificate.new cert
      result = store.verify client
      # ca cert is valid
      return true if ca_cert == cert
      !! result
    end


    private
    def store
       @store ||= OpenSSL::X509::Store.new.tap do |store|
         root = OpenSSL::X509::Certificate.new ca_cert
         store.add_cert root
       end
    end

    def ca_cert
      @ca_cert ||= File.read Grenache::Http.config.ca
    end
  end
end

