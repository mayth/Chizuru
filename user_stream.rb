require 'oauth'
require 'yaml'
require 'yajl'

require './source'

module Chizuru
  class UserStream < Source
    DEFAULT_USER_AGENT = 'TwitterBot/1.0 (Based on Chizuru)'

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

    def start
      puts '[UserStream] Start Streaming'
      connect do |json|
        @provider.receive(json)
      end
    end

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
