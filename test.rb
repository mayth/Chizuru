require './provider'
require './consumer'
require './credential'
require './user_stream'

class SimpleConsumer < Chizuru::Consumer
  def receive(data)
    deliver(data)
  end
end

class EchoDeliverer
  def deliver(data)
    p data
  end
end

class LoggingDeliverer
  def initialize(log_file)
    @log_file = log_file
  end

  def deliver(data)
    open(@log_file, 'a:utf-8') do |file|
      file.puts(data.inspect)
    end
  end
end

provider = Chizuru::Provider.new
consumer = SimpleConsumer.new
consumer.add_deliverer(EchoDeliverer.new)
consumer.add_deliverer(LoggingDeliverer.new('./stream.log'))
provider.add_consumer(consumer)
credential = Chizuru::Credential.new('credential.yaml')
source = Chizuru::UserStream.new(provider, credential, 'meitanbot', 'cert', 'meitanbot/2.0 (Chizuru/1.0)')

source.start
