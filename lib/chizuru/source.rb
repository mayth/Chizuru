module Chizuru
  # Represents a tweets source.
  #
  # Source provides events or statuses from Twitter API, or other any sources (for example, the log file of the streaming).
  class Source
    # Initializes an instance of Source with the given Provider.
    def initialize(provider)
      raise ArgumentError unless provider
      @provider = provider
    end
  end
end
