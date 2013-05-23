require './source'
require './provider'
require './consumer'
require './deliverer'
require './user_stream'

class SimpleConsumer < Chizuru::Consumer
  def receive(data)
    p data
  end
end

class LoggingConsumer < Chizuru::Consumer
  def initialize(log_file)
    @log_file = log_file
  end

  def receive(data)
    open(@log_file, 'a:utf-8') do |file|
      file.puts(data.inspect)
    end
  end
end

provider = Chizuru::Provider.new
provider.add_consumer(SimpleConsumer.new)
provider.add_consumer(LoggingConsumer.new('./stream.log'))
source = Chizuru::UserStream.new(provider, 'credential.yaml', 'meitanbot', 'cert', 'meitanbot/2.0 (Chizuru/1.0)')

source.start
