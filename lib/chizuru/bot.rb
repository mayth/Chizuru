require 'chizuru/credential'

module Chizuru
  # Helper for DSL
  class ConsumerHelper
    # Gets the consumer.
    attr_reader :consumer
    # Gets the credentials.
    attr_reader :credential

    # Initializes an instance of ConsumerHelper.
    # _cons_ is the consumer, _credential_ is the credential.
    def initialize(cons, credential)
      @consumer = cons
      @credential = credential
    end

    # Add deliverer
    def deliverer(deliv)
      @consumer.add_deliverer(deliv)
    end
  end

  # Represents a twitter-bot.
  class Bot
    # Gets or sets a source.
    attr_accessor :src
    # Gets or sets a provider.
    attr_accessor :provider
    # Gets or sets credentials. (This is given to the source.)
    attr_accessor :credential

    # Configures this bot.
    def self.configure(cred_path, &block)
      bot = Bot.new
      bot.credential = Credential.new(cred_path)
      bot.provider = Provider.new
      bot.instance_eval &block
      bot
    end

    # Adds a consumer.
    #
    # * If an instance of Consumer or its subclasses is given, it is used.
    # * If Class is given, initialize its instance, and use it. In this case, the rest arguments are passed to the constructor of the given class.
    def consumer(cons, *init_args, &block)
      if cons.instance_of? Class
        cons = cons.new(*init_args)
      end
      ch = ConsumerHelper.new(cons, credential)
      ch.instance_eval &block
      provider.add_consumer(ch.consumer)
    end

    # Sets a source.
    def source(src)
      @source = src
    end

    # Starts this bot.
    def start
      @source.start
    end
  end
end
