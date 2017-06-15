module Granache
  class Http < Grenache::Base
    class Configuration < Grenache::Configuration

      # thin server
      attr_accessor :thin_threaded, :thin_threadpool_size

      def initialize
        set_bool :thin_threaded, params, false
        set_val :thin_threadpool_size, params, 0
        super
      end
    end
  end

  module HttpConfigurable
    def self.included(base)
      base.extend(ClassMethods)
    end

    def config
      self.class.config
    end

    module ClassMethods
      def configure
        yield config
      end

      def config
        @configuration ||= Grenache::Http::Configuration.new
      end
    end
  end

  include HttpConfigurable
end
