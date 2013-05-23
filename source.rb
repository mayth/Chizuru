module Chizuru
  class Source
    def initialize(provider)
      raise ArgumentError unless provider
      @provider = provider
    end
  end
end
