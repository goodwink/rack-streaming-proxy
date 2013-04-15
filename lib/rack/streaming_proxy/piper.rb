require 'thread'

module Rack
  class Piper

    def initialize(*args)
      if RUBY_PLATFORM == 'java'
        @piper = JRubyPiper.new *args
      else
        @piper = Servolux::Piper.new *args
      end
    end

    def method_missing(method, *args, &block)
      @piper.send(method, *args, &block)
    end
  end

  class JRubyPiper
    def initialize(*args)
      @queue = Queue.new
    end

    def puts(obj)
      @queue << obj
    end

    def gets
      @queue.pop
    end

    def child(&block)
      Thread.new(&block)
    end

    def parent(&block)
      block.call
    end
  end
end
