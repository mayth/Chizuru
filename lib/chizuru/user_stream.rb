require 'oauth'
require 'yaml'
require 'yajl'

require 'chizuru/source'

module Chizuru
  # UserStream takes events or statuses from UserStreaming API.
  class UserStream < Source
    # The default value of User-Agent.
    DEFAULT_USER_AGENT = 'TwitterBot/1.0 (Based on Chizuru)'

    # Initializes an instance of UserStream.
    #
    # * _provider_ is the provider that this will give the events or statuses.
    # * _cred_ is the credentials.
    # * _screen_name_ is the screen name of this bot.
    # * _ca_file_path_ is the path for the certification file. It is required to establish the SSL connection with Twitter API.
    # * _user_agent_ is the User-Agent. Twitter strongly recommends set the User-Agent that includes the version of the client. See https://dev.twitter.com/docs/streaming-apis/connecting#User_Agent
    def initialize(provider, cred, screen_name, ca_file_path, user_agent = DEFAULT_USER_AGENT)
      super(provider)
      raise ArgumentError unless cred
      @credential = cred
      raise ArgumentError unless screen_name
      @screen_name = screen_name
      raise ArgumentError unless ca_file_path
      @ca_file = ca_file_path
      @user_agent = user_agent
    end

    # Starts the bot.
    def start
      puts '[UserStream] Start Streaming'
      connect do |json|
        @provider.receive(json)
      end
    end

    # Connects to UserStreaming API.
    #
    # The block will be given the events or statuses from Twitter API in JSON format.
    def connect
      uri = URI.parse("https://userstream.twitter.com/2/user.json?track=#{@screen_name}")

      https = Net::HTTP.new(uri.host, uri.port)
      https.use_ssl = true
      https.ca_file = @ca_file
      https.verify_mode = OpenSSL::SSL::VERIFY_PEER
      https.verify_depth = 5

      https.start do |https|
        request = Net::HTTP::Get.new(uri.request_uri,
                                     "User-Agent" => @user_agent,
                                     "Accept-Encoding" => "identity")
        request.oauth!(https, @credential.consumer, @credential.access_token)

        buf = ""
        https.request(request) do |response|
          response.read_body do |chunk|
            buf << chunk
            while ((line = buf[/.+?(\r\n)+/m]) != nil)
              begin
                buf.sub!(line, "")
                line.strip!
                status = Yajl::Parser.parse(line)
              rescue
                break
              end

              yield status
            end
          end
        end
      end
    end
  end
end
