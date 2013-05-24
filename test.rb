require './provider'
require './consumer'
require './credential'
require './user_stream'
require './bot'

class SimpleConsumer < Chizuru::Consumer
  def receive(data)
    deliver(data)
  end
end

class MeitanConsumer < Chizuru::Consumer
  HASHTAG_CANDIDATE_CHAR = ('a'..'z').to_a
  HASHTAG_LENGTH = 5
  def receive(data)
    return unless data['text']
    if data['text'].include?('めいたん')
      deliver({status: "@#{data['user']['screen_name']} めいたんじゃない！ ##{HASHTAG_CANDIDATE_CHAR.sample(HASHTAG_LENGTH).join}", in_reply_to: data})
    end
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

class TweetDeliverer
  def initialize(cred)
    @credential = cred
  end

  def deliver(data)
    opts = {status: data[:status]}
    if data[:in_reply_to]
      opts[:in_reply_to_status_id] = data[:in_reply_to]['id']
    end
    @credential.access_token.post(
      '/statuses/update.json', opts)
  end
end

bot = Chizuru::Bot.configure 'credential.yaml' do
  source Chizuru::UserStream.new(provider, credential, 'meitanbot', 'cert', 'meitanbot/2.0 (Chizuru/1.0)')
  echo_deliv = EchoDeliverer.new
  log_deliv = LoggingDeliverer.new('./stream.log')
  consumer SimpleConsumer do
    deliverer echo_deliv
    deliverer log_deliv
  end

  consumer MeitanConsumer do
    deliverer echo_deliv
    deliverer TweetDeliverer.new(credential)
  end
end

bot.start
