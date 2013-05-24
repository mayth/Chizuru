module Chizuru
  class Consumer
    def initialize
      @deliverers = []
      @queue = Queue.new
      Thread.new do
        while true
          data = @queue.deq
          dispatch(data)
        end
      end
    end

    def add_deliverer(deliverer)
      @deliverers << deliverer
    end
    
    def remove_deliverer(deliverer)
      @deliverers.delete(deliverer)
    end

    def deliver(data)
      @queue.enq data
    end

    def dispatch(data)
      @deliverers.each do |deliverer|
        Thread.new do 
          deliverer.deliver(data)
        end
      end
    end
  end
end
