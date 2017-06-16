module Grenache
  class Configuration
    # thin server
    attr_accessor :thin_threaded, :thin_threadpool_size
  end
end
