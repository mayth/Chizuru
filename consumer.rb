module Chizuru
  class Consumer
    attr :deliverers

    def initialize
      @deliverers = []
    end

    def add_deliverer(deliverer)
      @deliverers << deliverer
    end
    
    def remove_deliverer(deliverer)
      @deliverers.delete(deliverer)
    end
  end
end
