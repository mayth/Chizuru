require 'chizuru/credential'

module Chizuru
  class ConsumerHelper
    attr_reader :consumer, :credential

    def initialize(cons, credential)
      @consumer = cons
      @credential = credential
    end

    def deliverer(deliv)
      @consumer.add_deliverer(deliv)
    end
  end

  class Bot
    attr_accessor :src, :credential, :provider
    def self.configure(cred_path, &block)
      bot = Bot.new
      bot.credential = Credential.new(cred_path)
      bot.provider = Provider.new
      bot.instance_eval &block
      bot
    end

    def consumer(cons, *init_args, &block)
      if cons.instance_of? Class
        cons = cons.new(*init_args)
      end
      ch = ConsumerHelper.new(cons, credential)
      ch.instance_eval &block
      provider.add_consumer(ch.consumer)
    end

    def source(src)
      @source = src
    end

    def start
      @source.start
    end
  end
end
