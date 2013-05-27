require 'thread'

module Chizuru
  # Represents a tweets provider.
  #
  # Provider takes tweets from Source and provides them to Consumer.
  class Provider
    # Initializes an instance of Provider and starts the loop.
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

    # Adds a consumer.
    def add_consumer(cons)
      @consumers << cons
    end

    # Removes a consumer.
    def remove_consumer(cons)
      @consumers.delete(cons)
    end

    # On receiving a status from the source.
    def receive(data)
      @queue.enq data
    end

    # Dispatches the status to the consumers this has.
    def dispatch(data)
      @consumers.each do |consumer|
        Thread.new do
          consumer.receive(data)
        end
      end
    end
  end
end
