module Chizuru
  # Represents a consumer.
  # Consumer takes tweets from Source, and generates status and passes it to deliverers.
  class Consumer
    # Initializes an instance of Consumer and starts loop.
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

    # Adds deliverer.
    def add_deliverer(deliverer)
      @deliverers << deliverer
    end

    # Removes a deliverer.
    def remove_deliverer(deliverer)
      @deliverers.delete(deliverer)
    end

    # On delivering a status.
    def deliver(data)
      @queue.enq data
    end

    # Dispatches a status to deliverers this has.
    def dispatch(data)
      @deliverers.each do |deliverer|
        Thread.new do 
          deliverer.deliver(data)
        end
      end
    end
  end
end
