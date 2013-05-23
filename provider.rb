require 'thread'

module Chizuru
  class Provider
    def initialize
      @consumers = []
      @queue = Queue.new
      Thread.new do
        while (true)
          data = @queue.deq
          dispatch(data)
        end
      end
    end

    def add_consumer(cons)
      @consumers << cons
    end

    def remove_consumer(cons)
      @consumers.delete(cons)
    end

    def receive(data)
      puts '[Provider] Receive'
      @queue.enq data
    end

    def dispatch(data)
      puts '[Provider] Dispatch'
      @consumers.each do |consumer|
        Thread.new do
          consumer.receive(data)
        end
      end
    end
  end
end
